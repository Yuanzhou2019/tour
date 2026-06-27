import { Controller, Get } from '@nestjs/common';
import { ReputationService } from './reputation.service';

@Controller('reputations')
export class ReputationController {
  constructor(private readonly reputationService: ReputationService) {}

  @Get()
  list() {
    return this.reputationService.list();
  }
}
