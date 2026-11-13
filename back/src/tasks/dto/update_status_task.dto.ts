import { IsBoolean, IsNotEmpty } from 'class-validator';

export class UpdateStatusTaskDto {
    
    @IsBoolean()
    @IsNotEmpty()
    iniciated: boolean;

    @IsBoolean()
    @IsNotEmpty()
    completed: boolean;

}