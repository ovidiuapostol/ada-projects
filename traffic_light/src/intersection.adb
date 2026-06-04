--  intersection.adb
--  Package: Intersection
--  Purpose: Traffic light controller (state-machine + timing)
--  Author : Ovi
package body Intersection is

   protected body Intersection_Controller is

      --  Return the color of the North-South traffic line based on the
      --  on the current state of the finite-state-machine
      function NS_Color return Color is
      begin
         case Current_State is
            when NS_Green  => return Green;
            when NS_Yellow => return Yellow;
            when others    => return Red;
         end case;
      end NS_Color;

      --  Return the color of the North-South traffic line based on the
      --  on the current state of the finite-state-machine
      function EW_Color return Color is
      begin
         case Current_State is
            when EW_Green  => return Green;
            when EW_Yellow => return Yellow;
            when others    => return Red;
         end case;
      end EW_Color;

      --  Indicate whether the controller has reached the configured
      --  runtime limit and should stop execution.
      function Should_Stop return Boolean is
      begin
         return Stop_Flag;
      end Should_Stop;

      --  Advance the controller by one tick. This:
      --    * increments time spent in the current state
      --    * increments total runtime
      --    * checks whether runtime has expired
      --    * performs a state transition when the state's duration ends
      --  Called by Cyclic_Task_1s task
      procedure Tick is

         --  Cached state information for the current state:
         --    duration and next state.
         Info : constant State_Info := Transition_Table (Current_State);
      begin
         --  Update timers
         Time_In_State := Time_In_State + 1;
         Time_In_Run   := Time_In_Run + 1;

         --  Check if the controller should be stoped
         if Time_In_Run >= Run_Duration then
            Stop_Flag := True;
         end if;

         --  Perform the state transition when the state duration has expired
         if Time_In_State >= Info.Duration then
            Time_In_State := 0;
            Current_State := Info.Next_State;
         end if;

      end Tick;

   end Intersection_Controller;

end Intersection;
