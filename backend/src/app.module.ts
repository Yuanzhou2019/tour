import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TerminusModule } from '@nestjs/terminus';

import { buildDatabaseConfig } from './config/database.config';
import { HealthModule } from './modules/health/health.module';
import { PolicyModule } from './modules/policy/policy.module';
import { PoiModule } from './modules/poi/poi.module';
import { ReputationModule } from './modules/reputation/reputation.module';
import { ChecklistModule } from './modules/checklist/checklist.module';
import { CorrectionModule } from './modules/correction/correction.module';
import { UserModule } from './modules/user/user.module';
import { ContentPackModule } from './modules/content-pack/content-pack.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (configService: ConfigService) =>
        buildDatabaseConfig(configService),
    }),
    TerminusModule,
    HealthModule,
    PolicyModule,
    PoiModule,
    ReputationModule,
    ChecklistModule,
    CorrectionModule,
    UserModule,
    ContentPackModule,
  ],
})
export class AppModule {}
