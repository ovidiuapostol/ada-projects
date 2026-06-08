------------------------------------------------------------------------------
--  pedestrian.adb
--  Package: Pedestrian
--  Purpose:
--     Implements the movement logic for pedestrians in the traffic
--     simulation. Determines whether movement is allowed based on world
--     cell status and traffic-light state, and updates all pedestrian
--     positions accordingly.
--  Author : Ovi
------------------------------------------------------------------------------
with Intersection; use Intersection;
package body Pedestrian is
   ---------------------------------------------------------------------------
   --  Can_Move_EW
   --  Purpose:
   --     Determins whether an east-west pedestrian can move one cell left
   --     Checks world cell status and EW traffic-light color.
   ---------------------------------------------------------------------------
   function Can_Move_EW (P : Pedestrian) return Boolean is
      Status_Cell : Cell_Status;
   begin
      --  Prevent moving outside the world.
      if P.Pos.Col = 1 then
         return False;
      end if;

      --  Inspect the next cell to the west.
      Status_Cell := Get_World_Cell_Status (P.Pos.Row, P.Pos.Col - 1);

      case Status_Cell is

         when Free =>
            return True;

         when Taken =>
            return False;

         when Traffic_Light =>
            --  Allow movement if EW light is green OR pedestrian already
            --  passed the intersection center.
            if (Intersection_Controller.EW_Color = Green)
              or else (P.Pos.Col <= Central_Column)
            then
               return True;
            else
               return False;
            end if;

         when others =>
            return False;

      end case;
   end Can_Move_EW;

   --------------------------------------------------------------------------
   --  Can_Move_NS
   --  Purpose:
   --     Determines whether a north-south pedestrian may move one cell up
   --     Checks world cell status and NS traffic-light color.
   ---------------------------------------------------------------------------
   function Can_Move_NS (P : Pedestrian) return Boolean is
      Status_Cell : Cell_Status;
   begin
      --  Prevent moving outside the world.
      if P.Pos.Row = 1 then
         return False;
      end if;

      --  Inspect the next cell to the north.
      Status_Cell := Get_World_Cell_Status (P.Pos.Row - 1, P.Pos.Col);

      case Status_Cell is

         when Free =>
            return True;

         when Taken =>
            return False;

         when Traffic_Light =>
            --  Allow movement if NS light is green OR pedestrian already
            --  passed the intersection center.
            if (Intersection_Controller.NS_Color = Green)
              or else (P.Pos.Row <= Central_Row)
            then
               return True;
            else
               return False;
            end if;

         when others =>
            return False;

      end case;
   end Can_Move_NS;

   ---------------------------------------------------------------------------
   --  Move
   --  Purpose:
   --     Updates the logical positions of all pedestrians. Movement is
   --     direction dependent and uses the internal Can_Move_* helpers.
   --     A rename is used so updates apply directly to the array element.
   ---------------------------------------------------------------------------
   procedure Move is
   begin
      for I in Pedestrians'Range loop

         --  Create an alias for the current pedestrian.
         declare
            P : Pedestrian renames Pedestrians (I);
         begin

            case P.Direction is

               when NS =>
                  --  Move north if allowed.
                  if Can_Move_NS (P) then
                     P.Pos.Row := P.Pos.Row - 1;
                  end if;

               when EW =>
                  --  Move west if allowed.
                  if Can_Move_EW (P) then
                     P.Pos.Col := P.Pos.Col - 1;
                  end if;

            end case;

         end;

      end loop;
   end Move;

end Pedestrian;
