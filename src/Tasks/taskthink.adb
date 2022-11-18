With Ada.Real_Time; use Ada.Real_Time;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Execution_Time; use Ada.Execution_Time;

package body TaskThink is
   
  task body think is
      myClock_now : Time;
      myClock_next : Time;
      T : Time_Span := Milliseconds(900);
      Current_State : Directions := Stop;
      
   begin
         loop
            myClock_now := Clock;
         
            case Current_State is
            
            when Stop =>
               if Brain.GetMeasurementSensor1 > 10 then
                  MotorDriver.SetDirection (Forward);
                  Current_State := Forward;
               end if;
               
            when Forward =>
               
               if (Brain.GetMeasurementSensor1 < 10) and (Brain.GetMeasurementSensor1 > 1) then
                  Current_State := Backward;
                  MotorDriver.SetDirection (Backward);
                  myClock_next := Clock + T;
               end if;    
                
            when Backward =>
               
                  myClock_now := Clock;
               if (myClock_now > myClock_next) or ((Brain.GetMeasurementSensor2 < 10) and (Brain.GetMeasurementSensor2 > 1)) then
                  Current_State := Turn90_Left;
                  MotorDriver.SetDirection(Turn90_Left);
                  myClock_next := Clock + T;
               end if;
               
            when Turn90_Left =>
               
               myClock_now := Clock;
               
               if (myClock_now > myClock_next) then
                
                  if Brain.GetMeasurementSensor1 > 10 then
                     Current_State := Forward;
                     MotorDriver.SetDirection(Forward);
                  else               
                     Current_State := Turn90_Left;
                     MotorDriver.SetDirection(Turn90_Left);
                     myClock_next := Clock + T;
                  end if;
               end if; 
            end case;  
            
         delay until myClock_now + Milliseconds(50);
         
         end loop;
   end think;

end TaskThink;
