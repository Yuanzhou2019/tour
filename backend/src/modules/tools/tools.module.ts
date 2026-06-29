import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { FxRate } from './entities/fx-rate.entity';
import { EmergencyContact } from './entities/emergency-contact.entity';
import { Phrase } from './entities/phrase.entity';
import { ToolsService } from './tools.service';
import { ToolsController } from './tools.controller';

@Module({
  imports: [TypeOrmModule.forFeature([FxRate, EmergencyContact, Phrase])],
  controllers: [ToolsController],
  providers: [ToolsService],
})
export class ToolsModule {}