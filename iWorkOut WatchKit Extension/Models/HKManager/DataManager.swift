import Foundation
import HealthKit

class DataManager: NSObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate, ObservableObject {

    enum WorkoutState {
        case inactive, active, paused
    }

    var healthStore: HKHealthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?

    var activity: HKWorkoutActivityType = .functionalStrengthTraining

    @Published var state: WorkoutState = .inactive
    @Published var totalEnergyBurned: Double = 0
    @Published var lastHeartRate: Double = 0

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) { }

    func workoutSession(
        _ workoutSession: HKWorkoutSession,
        didChangeTo toState: HKWorkoutSessionState,
        from fromState: HKWorkoutSessionState, date: Date
    ) {
        DispatchQueue.main.async {
            switch toState {
            case .running:
                self.state = .active
            case .ended:
                self.save()
            case .paused:
                self.state = .paused
            case .stopped:
                self.state = .inactive
                self.totalEnergyBurned = 0
                self.lastHeartRate = 0
            default:
                break
            }
        }

    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) { }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            guard let statistics = workoutBuilder.statistics(for: quantityType) else { continue }

            DispatchQueue.main.async {
                switch statistics.quantityType {

                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                    self.lastHeartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0

                default:
                    let value = statistics.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
                    self.totalEnergyBurned = value

                }
            }
        }
    }

    func start() {
        let writing: Set<HKSampleType> = [
            .workoutType(),
            .quantityType(forIdentifier: .heartRate)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        let reading: Set<HKObjectType> = [
            .workoutType(),
            .quantityType(forIdentifier: .heartRate)!,
            .quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: writing, read: reading) { success, error in
            if success {
                self.beginWorkout()
            } else {
                print("error requesting healthsore authorization: \(error?.localizedDescription ?? "")")
            }
        }
    }

    private func beginWorkout() {
        let config: HKWorkoutConfiguration = HKWorkoutConfiguration()
        config.activityType = activity
        config.locationType = .indoor

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: config)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
            workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)

            workoutSession?.delegate = self
            workoutBuilder?.delegate = self

            workoutSession?.startActivity(with: Date())
            workoutBuilder?.beginCollection(withStart: Date(), completion: { success, error in
                guard success else {
                    print("error beginCollection \(error?.localizedDescription ?? "")")
                    return
                }
                DispatchQueue.main.async {
                    self.state = .active
                }
            })

        } catch {
            print(error.localizedDescription)
        }
    }

    func pause() {
        workoutSession?.pause()
    }

    func resume() {
        workoutSession?.resume()
    }

    func end() {
        workoutSession?.end()
    }

    func stop() {
        workoutSession?.stopActivity(with: Date())
    }

    private func save() {
        workoutBuilder?.endCollection(withEnd: Date()) { _, _ in
            self.workoutBuilder?.finishWorkout { _, _ in
                DispatchQueue.main.async {
                    self.state = .inactive
                }
            }
        }
    }

    private func discard() {
        workoutBuilder?.endCollection(withEnd: Date(), completion: { _, _ in
            self.workoutBuilder?.finishWorkout { _, _ in
                DispatchQueue.main.async {
                    self.state = .inactive
                }
            }
        })
    }
}
