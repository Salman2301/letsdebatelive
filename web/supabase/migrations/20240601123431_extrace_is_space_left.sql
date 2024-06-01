drop policy "Enable insert for authenticated users only" on "public"."live_debate_participants";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.is_space_left(live_debate_id uuid)
 RETURNS boolean
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$BEGIN
  RETURN (
    (SELECT COUNT(*) 
      FROM live_debate_participants AS ldp
      WHERE ldp.live_debate = live_debate_id) < 
    (SELECT ld.max_participants 
      FROM live_debate AS ld 
      WHERE ld.id = live_debate_id)
  );
END;$function$
;

create policy "Enable insert for authenticated users only"
on "public"."live_debate_participants"
as permissive
for insert
to authenticated, anon
with check (((( SELECT auth.uid() AS uid) = participant_id) AND is_space_left(live_debate)));



