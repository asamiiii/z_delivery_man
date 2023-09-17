abstract class PickupDetailsStates {}

class PickupDetailsInitialState extends PickupDetailsStates {}

class PickupDetailsLoadingState extends PickupDetailsStates {}

class PickupDetailsFailedState extends PickupDetailsStates {}

class PickupDetailsSuccessState extends PickupDetailsStates {}

class PickupDetailsGetMarkerSuccessState extends PickupDetailsStates {}

class PickupDetailsUpdateMarkerAndCircleSuccessState
    extends PickupDetailsStates {}

class PickupDetailsGetCurrentLocationSuccessState extends PickupDetailsStates {}

class PickupDetailsAddMarkerForOrdersSuccessState extends PickupDetailsStates {}

class PickupDetailsCalculateDistanceOfOrderesSuccessState
    extends PickupDetailsStates {}

class PickupDetailsNextStatusSuccessState extends PickupDetailsStates {}

class PickupDetailsNextStatusLoadingState extends PickupDetailsStates {}

class PickupDetailsNextStatusFailedState extends PickupDetailsStates {}

class PickupDetailsCollectOrderStatusLoadingState extends PickupDetailsStates {}

class PickupDetailsCollectOrderStatusFailedState extends PickupDetailsStates {}

class PickupDetailsCollectOrderStatusSuccessState extends PickupDetailsStates {}

class PickupDetailsChangeCheckBoxSuccessState extends PickupDetailsStates {}
