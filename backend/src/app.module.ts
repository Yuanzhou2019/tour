import { Module } from '@nestjs/common';
import { APP_INTERCEPTOR } from '@nestjs/core';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { TerminusModule } from '@nestjs/terminus';

import { buildTypeOrmConfig } from './config/typeorm.config';
import { HealthModule } from './modules/health/health.module';
import { PolicyModule } from './modules/policy/policy.module';
import { PoiModule } from './modules/poi/poi.module';
import { ReputationModule } from './modules/reputation/reputation.module';
import { ChecklistModule } from './modules/checklist/checklist.module';
import { CorrectionModule } from './modules/correction/correction.module';
import { UserModule } from './modules/user/user.module';
import { ContentPackModule } from './modules/content-pack/content-pack.module';
import { DiscoverModule } from './modules/discover/discover.module';
import { ToolsModule } from './modules/tools/tools.module';
import { SeedModule } from './seeds/seed.module';
import { AnonymousIdInterceptor } from './common/interceptors/anonymous-id.interceptor';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    TypeOrmModule.forRootAsync({
      useFactory: () => buildTypeOrmConfig(),
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
    DiscoverModule,
    ToolsModule,
    SeedModule,
  ],
  providers: [
    {
      provide: APP_INTERCEPTOR,
      useClass: AnonymousIdInterceptor,
    },
  ],
})
export class AppModule {}
