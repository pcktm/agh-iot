import { BaseEntity, Column, CreateDateColumn, Entity, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { LaundrySession } from './laundrySession.entity';

@Entity()
export class Measurement extends BaseEntity {

  @PrimaryGeneratedColumn()
  id: string;

  @ManyToOne(() => LaundrySession, laundrySession => laundrySession.measurements, { onDelete: 'CASCADE' })
  laundrySession: LaundrySession;

  @Column()
  temperature: number;

  @Column()
  humidity: number;

  @CreateDateColumn()
  createdAt: Date;
}
