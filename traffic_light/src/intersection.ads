--  intersection.ads
--  Package: Intersection
--  Purpose: Traffic light controller (state-machine + timing)
--  Author : Ovi
package Intersection is

   --  Traffic light colors used by both directions.
   type Color is (Red, Yellow, Green);

   --  Finite-state-machine states for the intersection controller
   --  The All_Red_* states act as a mandatory safety buffers between switching the right of way
   --  from one dirrection to the other
   type State is (NS_Green, NS_Yellow, All_Red_After_NS, EW_Green, EW_Yellow, All_Red_After_EW);

   --  Information describing a single FSM state
   --    Duration    - how long the state lasts (in ticks)
   --    Next_State  - which state follows after the duration expires
   type State_Info is record
     Duration   : Natural;
     Next_State : State;
   end record;

   --  Duration Constants (in ticks). These defines the timing
   --  profile of the traffic light cycle
   Green_Duration     : constant Natural := 6;
   Yellow_Duration    : constant Natural := 3;
   All_Red_Duration   : constant Natural := 2;
   Run_Duration       : constant Integer := 60;

   --  Transition table for the finite-state-machine. Each state maps to
   --  its duration and the next state to enter when the duration ends.
   Transition_Table : constant array (State) of State_Info :=
      (NS_Green         => (Duration => Green_Duration,   Next_State => NS_Yellow),
       NS_Yellow        => (Duration => Yellow_Duration,  Next_State => All_Red_After_NS),
       All_Red_After_NS => (Duration => All_Red_Duration, Next_State => EW_Green),
       EW_Green         => (Duration => Green_Duration,   Next_State => EW_Yellow),
       EW_Yellow        => (Duration => Yellow_Duration,  Next_State => All_Red_After_EW),
       All_Red_After_EW => (Duration => All_Red_Duration, Next_State => NS_Green));

   --  Intersection_Controller implements the traffic light state machine
   --  It advances one tick at a time, update the current state based on
   --  the transition table end exposes the curent collors for both
   --  directions. It also tracks the total run time and detect when the
   --  configured runtime has elapsed
   protected Intersection_Controller is

      --  Advance the controller by one tick. This may triger
      --  a state transition and increments the runtime counters
      procedure Tick;

      --  Current collor of the North-South direction
      function  NS_Color    return Color;

      --  Current collor of the East-West direction
      function  EW_Color    return Color;

      --  Returns True when the controller has reached Run_Duration
      --  and should stop the execution
      function  Should_Stop return Boolean;

   private
      Current_State : State   := NS_Green; -- Current finite-state-machine state
      Time_In_State : Integer := 0;        -- Number of ticks spent in the current state
      Time_In_Run   : Integer := 0;        -- Total number of ticks since the program started
      Stop_Flag     : Boolean := False;    -- this flag is to stop the program after 30s
   end Intersection_Controller;

end Intersection;
