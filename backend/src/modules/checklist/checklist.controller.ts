import { Controller, Get } from '@nestjs/common';
import { ChecklistService } from './checklist.service';

@Controller('checklist')
export class ChecklistController {
  constructor(private readonly checklistService: ChecklistService) {}

  @Get()
  list() {
    return this.checklistService.list();
  }
}
