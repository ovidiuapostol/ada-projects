-------------------------------------------------------------------------
--  scheduler.ads
--  Package: Scheduler
--  Purpose: Defines periodic cyclic tasks for the system:
--             * 1s task for the traffic light state machine
--             * 200ms task for the renderer
--  Author : Ovi
------------------------------------------------------------------------
with Ada.Real_Time;
with Intersection;
with Generic_Cyclic_Task;
with Renderer;
with Pedestrian;
with World_Model;

package Scheduler is

   --  Periods for the cyclic tasks [ms]
   Task_Recurence_1000ms : constant Natural := 1000;
   Task_recurence_200ms  : constant Natural := 200;

   --  1s cyclic task:
   --    Calls Intersection_Controller.Tick every 1000ms
   package Traffic_Light_FSM_Task is new Generic_Cyclic_Task
     (Job => Intersection.Intersection_Controller.Tick,
      Period => Ada.Real_Time.Milliseconds (Task_Recurence_1000ms));

   --  200ms cyclic task:
   --    Calls Renderer.Render every 200ms
   package Screen_Renderer_Task is new Generic_Cyclic_Task
     (Job => Renderer.Render,
      Period => Ada.Real_Time.Milliseconds (Task_recurence_200ms));

   --  200ms cyclic task:
   --    Updates world model (light + pedestrians) every 200ms
   package World_Update_Task is new Generic_Cyclic_Task
     (Job => World_Model.Update_World,
       Period => Ada.Real_Time.Milliseconds (Task_recurence_200ms));

   --  200ms cyclic task:
   --    Move Pedestrians every sec
   package Pedestrian_Movement_Task is new Generic_Cyclic_Task
     (Job => Pedestrian.Move,
      Period => Ada.Real_Time.Milliseconds (Task_Recurence_1000ms));

end Scheduler;
