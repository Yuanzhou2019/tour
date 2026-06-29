import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CorrectionController } from './correction.controller';
import { CorrectionService } from './correction.service';
import { Correction } from './entities/correction.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Correction])],
  controllers: [CorrectionController],
  providers: [CorrectionService],
})
export class CorrectionModule {}