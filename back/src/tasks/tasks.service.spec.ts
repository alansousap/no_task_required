import { Test } from '@nestjs/testing';
import { TasksService } from './tasks.service.js';
import { PrismaService } from '../prisma/prisma.service.js';
import { NotFoundException } from '@nestjs/common';

describe('Unit Tests for Tasks Service', () => {
    let tasksService: TasksService;
    const prismaMock = {
        tasks: {
            findMany: vi.fn(),
            findFirst: vi.fn(),
            create: vi.fn(),
            update: vi.fn(),
        }
    };

    beforeAll(async () => {
        const moduleRef = await Test.createTestingModule({
            providers: [
                TasksService,
                { provide: PrismaService, useValue: prismaMock }
            ],
        }).compile();

        tasksService = moduleRef.get(TasksService);
    });

    it('Should return tasks by a date', async () => {
        const tasksList = [
            { id:1, description: 'test task 1', date: new Date(), iniciated: false, completed: false },
            { id:2, description: 'test task 2', date: new Date(), iniciated: false, completed: false }
        ];
        prismaMock.tasks.findMany.mockResolvedValue(tasksList);

        const date = new Date().toISOString().split("T")[0];

        expect(await tasksService.findTasksWithDate(date)).toEqual(tasksList);
        expect(prismaMock.tasks.findMany).toHaveBeenCalledWith({
            where: { 
                date: new Date(`${date}T00:00:00.000Z`)
            }
        });
    });

    it('Should throw a exception with the message task already created', async () => {
        const mockTask = { id:1, description: 'test task 1', date: new Date(), iniciated: false, completed: false };
        prismaMock.tasks.findFirst.mockResolvedValue(mockTask);

        await expect(tasksService.createTask('test task 1')).rejects.toThrow('Task already created');
        expect(prismaMock.tasks.findFirst).toHaveBeenCalledWith({
            where: { description:'test task 1' }
        });
    });

    it('Should create a task', async () => {
        const dateISO = new Date().toISOString().split('T')[0];
        const date = new Date(`${dateISO}T00:00:00.000Z`);
        const description = 'test task 1';

        const mockTask = { id:1, description, date, iniciated: false, completed: false };
        prismaMock.tasks.create.mockResolvedValue(mockTask);
        prismaMock.tasks.findFirst.mockResolvedValue(null);

        expect(await tasksService.createTask(description)).toEqual(mockTask);
        expect(prismaMock.tasks.findFirst).toHaveBeenCalledWith({
            where: { description }
        });
        expect(prismaMock.tasks.create).toHaveBeenCalledWith({
            data: {
                description,
                completed: false,
                iniciated: false,
                date,
            }
        });
    });

    it('Should update the status of the task', async () => {
        const id = 1;
        const iniciated = true;
        const completed = true;
        const mockTask = { id, description: 'test task 1', date: new Date(), iniciated, completed };
        prismaMock.tasks.update.mockResolvedValue(mockTask);

        expect(await tasksService.updateStatusTask(id,iniciated,completed)).toEqual(mockTask);
        expect(prismaMock.tasks.update).toHaveBeenCalledWith({
            where: { id },
            data: { iniciated, completed }
        });
    });

    it('Should throw a exception with the message task not found', async () => {
        const id = 1;
        const iniciated = true;
        const completed = true;
        prismaMock.tasks.update.mockRejectedValue(new NotFoundException('Task not found'));

        await expect(tasksService.updateStatusTask(id,iniciated,completed)).rejects.toThrow('Task not found');
        expect(prismaMock.tasks.update).toHaveBeenCalledWith({
            where: { id },
            data: { iniciated, completed }
        });
    });

});