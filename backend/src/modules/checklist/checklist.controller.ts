import { Controller, Get, Param, Query } from '@nestjs/common';
import { ChecklistService } from './checklist.service';

@Controller('checklists')
export class ChecklistController {
  constructor(private readonly checklistService: ChecklistService) {}

  @Get()
  list(@Query() query: { country?: string; reason?: string; city?: string }) {
    return this.checklistService.list(query);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.checklistService.findById(id);
  }
}