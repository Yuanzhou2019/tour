import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  Index,
  UpdateDateColumn,
} from 'typeorm';

export interface RankItem {
  poiId: string;
  reasonZh: string;
  reasonEn: string;
  order: number;
}

@Entity('ranks')
@Index(['category', 'order'])
export class Rank {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!:
    | 'dining'
    | 'shopping'
    | 'attraction'
    | 'family'
    | 'couple'
    | 'business'
    | 'solo'
    | 'warning';

  @Column({ length: 200 })
  titleZh!: string;

  @Column({ length: 200 })
  titleEn!: string;

  @Column({ type: 'jsonb' })
  items!: RankItem[];

  @Column({ type: 'int', default: 0 })
  order!: number;

  @UpdateDateColumn()
  updatedAt!: Date;
}
