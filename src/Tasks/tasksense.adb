With Ada.Real_Time; use Ada.Real_Time;
With MicroBit.Console; use MicroBit.Console;
With Ultrasonic; use Ultrasonic;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Execution_Time; use Ada.Execution_Time;

package body TaskSense is

    task body sense is
      myClock : Time;
      Distance_front : Distance_cm := 0;
      Distance_back : Distance_cm := 0;
      
      --Time_Now_Stopwatch : Time;
      --Time_Now_CPU : CPU_Time;
      --Elapsed_Stopwatch : Time_Span;
      --Elapsed_CPU : Time_Span;
      --AmountOfMeasurement: Integer := 10;
     
   begin
      loop
         
         myClock := Clock;
         
            --Elapsed_Stopwatch := Time_Span_Zero;
            --Elapsed_CPU := Time_Span_Zero;

           -- for Index in 1..AmountOfMeasurement loop
            --   Time_Now_Stopwatch := Clock;
            --   Time_Now_CPU := Clock;
         
            Ultrasonic.Setup(10,4);
            Distance_front := Read;
            Ultrasonic.Setup(10,19);
            Distance_back := Read;
         
            Brain.SetMeasurementSensor1 (Integer'Value(Ultrasonic.Distance_cm'Image(Distance_front)));
            Brain.SetMeasurementSensor2 (Integer'Value(Ultrasonic.Distance_cm'Image(Distance_back)));
         
            Ada.Text_IO.Put_Line ("Read_front" & Distance_cm'Image(Distance_front));
            Ada.Text_IO.Put_Line ("Read_back" & Distance_cm'Image(Distance_back));
            
            --Elapsed_CPU := Elapsed_CPU + (Clock - Time_Now_CPU);
            --Elapsed_Stopwatch := Elapsed_Stopwatch + (Clock - Time_Now_Stopwatch);
           -- end loop;

            --Elapsed_CPU := Elapsed_CPU / AmountOfMeasurement;
            --Elapsed_Stopwatch := Elapsed_Stopwatch / AmountOfMeasurement;

            --Ada.Text_IO.Put_Line ("CPU time: " & To_Duration (Elapsed_CPU)'Image & " seconds");
            --Ada.Text_IO.Put_Line ("Stopwatch time: " & To_Duration (Elapsed_Stopwatch)'Image & " seconds");
         
         
            delay until myClock + Milliseconds(70); --random period
                                                              
    end loop;  
      
    end sense;

end TaskSense;
