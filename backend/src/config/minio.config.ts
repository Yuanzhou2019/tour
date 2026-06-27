import { ConfigService } from '@nestjs/config';

export interface MinioConfig {
  endPoint: string;
  port: number;
  useSSL: boolean;
  accessKey: string;
  secretKey: string;
  bucket: string;
}

export const buildMinioConfig = (configService: ConfigService): MinioConfig => ({
  endPoint: configService.get<string>('MINIO_ENDPOINT', 'localhost'),
  port: parseInt(configService.get<string>('MINIO_PORT', '9000'), 10),
  useSSL: configService.get<string>('MINIO_USE_SSL', 'false') === 'true',
  accessKey: configService.get<string>('MINIO_ACCESS_KEY', 'sightour'),
  secretKey: configService.get<string>('MINIO_SECRET_KEY', 'sightour'),
  bucket: configService.get<string>('MINIO_BUCKET', 'sightour'),
});
