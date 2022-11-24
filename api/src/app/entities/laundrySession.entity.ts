// eslint-disable-next-line @typescript-eslint/no-unused-vars
import { BaseEntity, Column, Entity, PrimaryGeneratedColumn, ManyToOne, OneToMany, CreateDateColumn } from 'typeorm';
import { User } from './user.entity';
import { Device } from './device.entity';
import { Measurement } from './measurement.entity';

@Entity()
export class LaundrySession extends BaseEntity {

  @PrimaryGeneratedColumn('uuid')
  id: number;

  @Column()
  name: string;

  @Column()
  icon: string;

  @Column()
  color: string;

  @ManyToOne(() => User, user => user.laundrySessions, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Device, device => device.laundrySessions)
  device: Device;

  @OneToMany(() => Measurement, measurement => measurement.laundrySession)
  measurements: Measurement[];

  @CreateDateColumn()
  startedAt: Date;

  @Column({ nullable: true })
  finishedAt: Date;
}
