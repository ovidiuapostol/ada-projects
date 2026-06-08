------------------------------------------------------------------------------
--  world_model.ads
--  Package: World_Model
--  Purpose:
--     Defines the world grid, coordinate system, traffic‑light positions,
--     and utility operations for querying and updating the simulation map.
--     Provides the static map initialization and pedestrian update hooks.
--  Author : Ovi
------------------------------------------------------------------------------
package World_Model is
   ---------------------------------------------------------------------------
   --  World geometry and key coordinates
   ---------------------------------------------------------------------------
   World_Rows      : constant := 25;
   World_Columns   : constant := 80;

   Central_Row     : constant := 12;
   Central_Column  : constant := 40;

   --  Traffic light positions
   North_Light_Row : constant := 10;
   North_Light_Col : constant := 40;

   South_Light_Row : constant := 14;
   South_Light_Col : constant := North_Light_Col;

   East_Light_Row  : constant := 12;
   East_Light_Col  : constant := 42;

   West_Light_Row  : constant := East_Light_Row;
   West_Light_Col  : constant := 38;

   ---------------------------------------------------------------------------
   --  Index types for world adressing
   ---------------------------------------------------------------------------
   subtype Row_Index is Positive range 1 .. World_Rows;
   subtype Col_Index is Positive range 1 .. World_Columns;

   ---------------------------------------------------------------------------
   --  Cell status classification
   ---------------------------------------------------------------------------
   type Cell_Status is (Free, Taken, Traffic_Light);

   ---------------------------------------------------------------------------
   --  World grid representation
   ---------------------------------------------------------------------------
   type World_Array is array (Row_Index, Col_Index) of Character;
   World : World_Array;

   ---------------------------------------------------------------------------
   --  Traffic-light position record
   ---------------------------------------------------------------------------
   type Light_Pos is record
      Row : Row_Index;
      Col : Col_Index;
   end record;

   --  Predifined traffic-light positions
   North_Light_Pos : constant Light_Pos := (Row => North_Light_Row,
                                            Col => North_Light_Col);
   South_Light_Pos : constant Light_Pos := (Row => South_Light_Row,
                                            Col => South_Light_Col);
   East_Light_Pos  : constant Light_Pos := (Row => East_Light_Row,
                                           Col => East_Light_Col);
   West_Light_Pos  : constant Light_Pos := (Row => West_Light_Row,
                                            Col => West_Light_Col);
   --  Initialization state
   Initialized : Boolean := False;

   ---------------------------------------------------------------------------
   --  Operations
   --------------------------------------------------------------------------

   --  Build the static ASCII map (roads, intersection, empty cells)
   procedure Init_Static_Map;

   --  Update the World array based on the imputs from traffic-lights i.e.
   --  Intersection Controller and persons.
   --  It is called by the scheduler
   procedure Update_World;

   --  Query the status of a world cell. It is used by the movement logic
   function Get_World_Cell_Status (R : Row_Index; C : Col_Index) return Cell_Status;

end World_Model;
