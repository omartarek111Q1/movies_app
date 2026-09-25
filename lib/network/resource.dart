enum ResourceStatus { initial, loading, success, error }

class Resource<T> {
  final ResourceStatus status;
  final T? data;
  final String? errorMessage;

  Resource._({required this.status, this.data, this.errorMessage});

  factory Resource.initial() => Resource._(status: ResourceStatus.initial);

  factory Resource.loading() => Resource._(status: ResourceStatus.loading);

  factory Resource.success(T data) => Resource._(status: ResourceStatus.success, data: data);

  factory Resource.error(String errorMessage) => Resource._(status: ResourceStatus.error, errorMessage: errorMessage);

  bool get isInitial => status == ResourceStatus.initial;
  bool get isLoading => status == ResourceStatus.loading;
  bool get isSuccess => status == ResourceStatus.success;
  bool get isError => status == ResourceStatus.error;
}