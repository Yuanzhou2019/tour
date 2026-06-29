import { Controller, Get, Query } from '@nestjs/common';
import { PolicyService } from './policy.service';

@Controller('policies')
export class PolicyController {
  constructor(private readonly policyService: PolicyService) {}

  @Get()
  list(
    @Query() query: { country?: string; reason?: string; city?: string; category?: string },
  ) {
    return this.policyService.list(query);
  }
}
