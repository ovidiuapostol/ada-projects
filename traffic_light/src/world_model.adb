------------------------------------------------------------------------------
--  world_model.adb
--  Package: World_Model
--  Purpose:
--     Implements the world grid, coordinate system, traffic light positions,
--     and utility operations for querying and updating the simulation map.
--  Author : Ovi
------------------------------------------------------------------------------
with Intersection;
with Pedestrian;
package body World_Model is

   ---------------------------------------------------------------------------
   --  Convert a logical traffic-light color into a single ASCII character.
   --  Used only for rendering; movement logic uses the Color type directly.
   ---------------------------------------------------------------------------
   function Color_To_Char (C : Intersection.Color) return Character is
   begin
      case C is
         when Intersection.Red    => return 'R';
         when Intersection.Yellow => return 'Y';
         when Intersection.Green  => return 'G';
      end case;
   end Color_To_Char;

   ---------------------------------------------------------------------------
   --  Write the north south road layout as a vertical line through the center
   --  column into the world array
   ---------------------------------------------------------------------------
   procedure Add_NS_Road is
   begin
      for Row in World'Range (1) loop
         World (Row, Central_Column) := '|';
      end loop;
   end Add_NS_Road;

   ---------------------------------------------------------------------------
   --  Write the east west road layout as an horizontal line through the center
   --  row into the world array
   ---------------------------------------------------------------------------
   procedure Add_EW_Road is
   begin
      for Col in World'Range (2) loop
         World (Central_Row, Col) := '-';
      end loop;
   end Add_EW_Road;

   ---------------------------------------------------------------------------
   --  Mark the geometric center of the intersection
   ---------------------------------------------------------------------------
   procedure Add_Center is
   begin
      World (Central_Row, Central_Column) := '+';
   end Add_Center;

   ---------------------------------------------------------------------------
   --  Remove all pedestrian markers ('P') from the world array and restore
   --  the underlying static background (road or empty space).
   --
   --  This prepares the world array for writing updated pedestrian positions.
   --  Rendering is done later by the frame builder.
   ---------------------------------------------------------------------------
   procedure Clear_Pedestrians is
   begin
      for Row in World'Range (1) loop
         for Col in World'Range (2) loop
            if World (Row, Col) = 'P' then
               --  restore background based on coordinates
               if Row = Central_Row and Col = Central_Column then
                  World (Row, Col) := '+';
               elsif Col = Central_Column then
                  World (Row, Col) := '|';
               elsif Row = Central_Row then
                  World (Row, Col) := '-';
               else
                  World (Row, Col) := ' ';
               end if;
            end if;
         end loop;
      end loop;
   end Clear_Pedestrians;

   --------------------------------------------------------------------------
   --  Write current pedestrian positions into the world array.
   --  Movement logic is handled in Pedestrian; this procedure only updates the
   --  world representation. Rendering is done later by the frame builder.
   ---------------------------------------------------------------------------
   procedure Update_World_Pedestrians is
   begin
      Clear_Pedestrians;
      for P of Pedestrian.Pedestrians loop
         World (P.Pos.Row, P.Pos.Col) := 'P';
      end loop;
   end Update_World_Pedestrians;

   ---------------------------------------------------------------------------
   --  Initialize the static world array: clear all cells, draw roads, and
   --  mark the intersection center. Dynamic elements (lights, pedestrians)
   --  are added during world updates.
   ---------------------------------------------------------------------------
   procedure Init_Static_Map is
   begin
      for Row in World'Range (1) loop
         for Col in World'Range (2) loop
            World (Row, Col) := ' ';
         end loop;
      end loop;

      Add_NS_Road;
      Add_EW_Road;
      Add_Center;
   end Init_Static_Map;

   ---------------------------------------------------------------------------
   --  Return the logical status of a world cell for movement decisions.
   --
   --  Rules:
   --     'P' -> Taken (ocupied by a pedestrian)
   --     'R','Y','G' -> Traffic_Light (Green allows movement)
   --     '|','-','+',' ' -> Free (road or empty space)
   ---------------------------------------------------------------------------
   function Get_World_Cell_Status (R : Row_Index; C : Col_Index)
     return Cell_Status
   is
   begin
      case World (R, C) is
         when '|' | '-' | '+' | ' ' =>
            return Free;
         when 'R' | 'Y' | 'G' =>
            return Traffic_Light;
         when 'P' =>
            return Taken;
         when others =>
            return Taken;
      end case;
   end Get_World_Cell_Status;

   ---------------------------------------------------------------------------
   --  Update the world array with the current traffic-light status/characters.
   --  The logical light state is computed in Intersection_Controller.
   --  This procedure only writes the representation into the world array.
   ---------------------------------------------------------------------------
   procedure Update_Traffic_Lights is
   begin
      World (North_Light_Pos.Row, North_Light_Pos.Col) := Color_To_Char (Intersection.Intersection_Controller.NS_Color);
      World (South_Light_Pos.Row, South_Light_Pos.Col) := Color_To_Char (Intersection.Intersection_Controller.NS_Color);
      World (East_Light_Pos.Row, East_Light_Pos.Col) := Color_To_Char (Intersection.Intersection_Controller.EW_Color);
      World (West_Light_Pos.Row, West_Light_Pos.Col) := Color_To_Char (Intersection.Intersection_Controller.EW_Color);
   end Update_Traffic_Lights;

   ---------------------------------------------------------------------------
   --  Update all dynamic elements in the world array:
   --     - traffic lights
   --     - pedestrians
   --
   --  This prepares the world array for the renderer, which builds the frame.
   --  Order matters: pedestrians overwrite light characters visually if they
   --  stand on the same cell. This is acceptable for the current version.
   ---------------------------------------------------------------------------
   procedure  Update_World is
   begin
      Update_Traffic_Lights;
      Update_World_Pedestrians;
   end Update_World;
end World_Model;
