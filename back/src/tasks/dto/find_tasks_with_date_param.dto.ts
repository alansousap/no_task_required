import { IsDateString, IsNotEmpty } from "class-validator";

export class findTasksWithDateParamDto {

    @IsNotEmpty()
    @IsDateString()
    date: string;
    
}