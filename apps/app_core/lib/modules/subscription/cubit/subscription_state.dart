part of 'subscription_cubit.dart';

enum SubscriptionStateStatus {
  initial,
  loading,
  plansLoaded,
  getPlansError,
  error,
  purchaseLoading,
  purchaseFailed,
  purchaseSuccess,
  purchaseRestored,
  purchaseCancelled;

  bool get isLoading => this == loading;
}

enum PlanType { basic, premium }

class SubscriptionState extends Equatable {
  const SubscriptionState({
    this.status = SubscriptionStateStatus.initial,
    this.plans = const [],
    this.planType = PlanType.basic,
    this.currentPlan,
  });

  final SubscriptionStateStatus status;
  final List<ProductDetails> plans;
  final PlanType planType;
  final Subscription? currentPlan;

  @override
  List<Object?> get props => [plans, status, planType, currentPlan];

  SubscriptionState copyWith({
    SubscriptionStateStatus? status,
    List<ProductDetails>? plans,
    PlanType? planType,
    Subscription? currentPlan,
  }) {
    return SubscriptionState(
      status: status ?? this.status,
      plans: plans ?? this.plans,
      planType: planType ?? this.planType,
      currentPlan: currentPlan ?? this.currentPlan,
    );
  }
}
