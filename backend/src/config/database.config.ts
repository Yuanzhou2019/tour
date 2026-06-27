import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

export const buildDatabaseConfig = (
  configService: ConfigService,
): TypeOrmModuleOptions => ({
  type: 'postgres',
  host: configService.get<string>('DB_HOST', 'localhost'),
  port: parseInt(configService.get<string>('DB_PORT', '5432'), 10),
  username: configService.get<string>('DB_USER', 'sightour'),
  password: configService.get<string>('DB_PASS', 'sightour'),
  database: configService.get<string>('DB_NAME', 'sightour'),
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  synchronize: false, // migrations-only in production
  autoLoadEntities: true,
  logging: configService.get<string>('NODE_ENV') === 'development' ? 'all' : ['error'],
});
