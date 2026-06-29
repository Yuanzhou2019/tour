import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

export interface ChecklistItem {
  id: string;
  titleZh: string;
  titleEn: string;
  detailZh?: string;
  detailEn?: string;
  officialUrl?: string;
  order: number;
}

@Entity('checklists')
@Index(['country', 'reason', 'city'])
export class Checklist {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 8 })
  country!: string;

  @Column({ length: 32 })
  reason!: string;

  @Column({ length: 16, default: 'SH' })
  city!: string; // SH | BJ | GZ | OTHER

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'jsonb' })
  items!: ChecklistItem[];
}
