import 'package:api/presentation/bloc/resource/single/single_resource_event.dart';
import 'package:api/presentation/bloc/resource/single/single_resource_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleResourceBloc
    extends Bloc<SingleResourceEvent, SingleResourceState> {
  SingleResourceBloc() : super(InitialSingleResourceState());
}
