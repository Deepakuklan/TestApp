import 'package:dart_mappable/dart_mappable.dart';
import 'file_dto.dart';
import 'info_register_dto.dart';

part 'prepare_upload_request_dto.mapper.dart';

@MappableClass()
class PrepareUploadRequestDto with PrepareUploadRequestDtoMappable {
  final InfoRegisterDto info;
  final Map<String, FileDto> files;

  const PrepareUploadRequestDto({
    required this.info,
    required this.files,
  });

  static const fromJson = PrepareUploadRequestDtoMapper.fromJson;
}
