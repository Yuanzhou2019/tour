import { Body, Controller, Delete, Get, Param, Patch, Post, Query, UseGuards } from '@nestjs/common';
import { ChecklistService, ToggleItemDto } from './checklist.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

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

  @Patch(':id/toggle')
  toggle(@Param('id') id: string, @Body() dto: ToggleItemDto) {
    return this.checklistService.toggleItem(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() dto: any) {
    return this.checklistService.create(dto);
  }

  @UseGuards(JwtAuthGuard)
  @Patch(':id')
  update(@Param('id') id: string, @Body() dto: any) {
    return this.checklistService.update(id, dto);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  delete(@Param('id') id: string) {
    return this.checklistService.delete(id);
  }
}