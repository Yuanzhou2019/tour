import { Controller, Get } from '@nestjs/common';
import { CorrectionService } from './correction.service';

@Controller('corrections')
export class CorrectionController {
  constructor(private readonly correctionService: CorrectionService) {}

  @Get()
  list() {
    return this.correctionService.list();
  }
}
