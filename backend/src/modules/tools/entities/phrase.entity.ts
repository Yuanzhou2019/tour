import { Entity, PrimaryGeneratedColumn, Column, Index } from 'typeorm';

@Entity('phrases')
@Index(['category', 'order'])
export class Phrase {
  @PrimaryGeneratedColumn('uuid')
  id!: string;

  @Column({ length: 32 })
  category!: 'customs' | 'taxi' | 'dining' | 'medical' | 'emergency' | 'shopping';

  @Column({ type: 'text' })
  en!: string;

  @Column({ type: 'text' })
  zh!: string;

  @Column({ type: 'text' })
  pinyin!: string;

  @Column({ type: 'int', default: 0 })
  order!: number;
}