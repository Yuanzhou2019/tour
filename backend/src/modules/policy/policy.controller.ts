import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { PolicyService } from './policy.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('policies')
export class PolicyController {
  constructor(private readonly policyService: PolicyService) {}

  @Get()
  list(
    @Query() query: { country?: string; reason?: string; city?: string; category?: string },
  ) {
    return this.policyService.list(query);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.policyService.findById(id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() dto: any) {
    return this.policyService.create(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: any) {
    return this.policyService.update(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.policyService.delete(id);
  }
}
