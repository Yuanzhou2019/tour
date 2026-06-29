import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('discover_cards')
@Index(['category', 'order'])
export class DiscoverCard {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!: 'curated' | 'authentic' | 'heads_up';

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'text' })
  summaryZh!: string;

  @Column({ type: 'text' })
  summaryEn!: string;

  @Column({ length: 500 })
  imageUrl!: string;

  @Column({ type: 'text', array: true, default: [] })
  relatedPoiIds!: string[];

  @Column({ type: 'int', default: 0 })
  order!: number;
}
