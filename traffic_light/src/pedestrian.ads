------------------------------------------------------------------------------
--  pedestrian.ads
--  Package: Pedestrian
--  Purpose:
--     Defines pedestrian entities and their initial positions for the
--     traffic-light simulation. Provides the public Move procedure used
--     to update all pedestrian positions.
--  Author : Ovi
------------------------------------------------------------------------------

with World_Model; use World_Model;

package Pedestrian is
   --  Movement direction of a pedestrian.
   type Move_Direction is (NS, EW);

   --  Grid position of a pedestrian.
   type Position is record
      Row : Row_Index;
      Col : Col_Index;
   end record;

   --  Combined direction + position (utility type for later use).
   type Direction_Pos is record
      Dir : Move_Direction;
      Pos : Position;
   end record;

   --  Pedestrian entity
   type Pedestrian is record
      Direction : Move_Direction := NS;
      Pos : Position;
      Right_Of_Way : Boolean;  --   for future use
   end record;

   --  Array of pedestrians used in simulation
   type Pedestrians_Array is array (1 .. 3) of Pedestrian;

   --  Initial pedestrian positions
   Pedestrians : Pedestrians_Array :=
     ((Direction        => NS,
        Pos              => (Row => South_Light_Row + 6,
                             Col => Central_Column),
        Right_Of_Way     => False),

       (Direction        => NS,
        Pos              => (Row => South_Light_Row + 4,
                             Col => Central_Column),
        Right_Of_Way     => False),

       (Direction        => EW,
        Pos              => (Row => Central_Row,
                             Col => Central_Column + 10),
        Right_Of_Way     => False)
      );

   --  update the positions of all pedestrians
   procedure Move;

end Pedestrian;
