-- Run AFTER mock_pause_resume.sql and the installed grading SQL.
-- SSC CGL Tier-I full papers: four equal time windows, 25 questions each.
BEGIN;
CREATE OR REPLACE FUNCTION public.ssc_cgl_filter_answers(p_attempt UUID,p_incoming JSONB)
RETURNS JSONB LANGUAGE plpgsql SECURITY DEFINER SET search_path='' AS $$
DECLARE a public.mock_attempts%ROWTYPE; t public.mock_tests%ROWTYPE;
 v_section INT; v_total INT; v_input JSONB; v_result JSONB;
BEGIN
 SELECT * INTO a FROM public.mock_attempts WHERE id=p_attempt AND student_id=auth.uid() FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Attempt unavailable'; END IF;
 SELECT * INTO t FROM public.mock_tests WHERE id=a.mock_test_id;
 IF t.title !~* '\mSSC\s+CGL\M' OR t.title ~* 'tier[\s-]*(ii\M|2\M)' THEN RETURN p_incoming; END IF;
 SELECT count(*) INTO v_total FROM public.mock_questions WHERE mock_test_id=t.id;
 IF v_total<>100 THEN RAISE EXCEPTION 'SSC CGL sectional timing requires 100 questions'; END IF;
 v_section:=least(4,greatest(0,floor(extract(epoch FROM
  (coalesce(a.paused_at,now())-a.started_at-a.paused_duration))/(t.duration_minutes*60.0/4))::INT));
 IF jsonb_typeof(p_incoming)='array' THEN
  SELECT coalesce(jsonb_object_agg(x->>'question_id',x->'selected_answer'),'{}'::jsonb)
  INTO v_input FROM jsonb_array_elements(p_incoming) x;
 ELSE v_input:=p_incoming; END IF;
 IF jsonb_typeof(v_input) IS DISTINCT FROM 'object' THEN RAISE EXCEPTION 'Invalid responses'; END IF;
 -- Past sections retain their last server-saved responses. Future responses are discarded.
 SELECT coalesce(jsonb_object_agg(q.id::TEXT,
  CASE WHEN q.section_no<v_section THEN a.draft_answers->q.id::TEXT ELSE v_input->q.id::TEXT END),'{}'::jsonb)
 INTO v_result FROM (
  SELECT id,((row_number() OVER(ORDER BY display_order,id)-1)/25)::INT AS section_no
  FROM public.mock_questions WHERE mock_test_id=t.id
 ) q WHERE q.section_no<=v_section AND coalesce(
  CASE WHEN q.section_no<v_section THEN a.draft_answers->q.id::TEXT ELSE v_input->q.id::TEXT END,'null'::jsonb)<>'null'::jsonb;
 IF jsonb_typeof(p_incoming)='array' THEN
  SELECT coalesce(jsonb_agg(jsonb_build_object('question_id',key,'selected_answer',value)),'[]'::jsonb)
  INTO v_result FROM jsonb_each(v_result);
 END IF;
 RETURN v_result;
END; $$;
REVOKE ALL ON FUNCTION public.ssc_cgl_filter_answers(UUID,JSONB) FROM PUBLIC,anon,authenticated;

-- Preserve the installed grader, session-token checks and all non-SSC behaviour.
DO $patch$
DECLARE signature TEXT; definition TEXT; position_begin INT;
BEGIN
 FOREACH signature IN ARRAY ARRAY['public.save_mock_attempt(uuid,uuid,jsonb,jsonb,boolean)',
                                  'public.submit_mock_attempt(uuid,jsonb)'] LOOP
  definition:=replace(pg_get_functiondef(signature::regprocedure),chr(13),'');
  IF position('ssc_cgl_filter_answers' IN definition)>0 THEN CONTINUE; END IF;
  position_begin:=strpos(definition,E'BEGIN\n');
  IF position_begin=0 THEN RAISE EXCEPTION 'Unknown function layout: %',signature; END IF;
  definition:=overlay(definition placing E'BEGIN\n    p_answers := public.ssc_cgl_filter_answers(p_attempt_id,p_answers);\n'
   FROM position_begin FOR length(E'BEGIN\n'));
  EXECUTE definition;
 END LOOP;
END; $patch$;
COMMIT;
