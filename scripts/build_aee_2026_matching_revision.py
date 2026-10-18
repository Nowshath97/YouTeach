"""Make an attempt-safe revised edition with three matching items per paper."""
import copy
import json
import build_aee_2026_mocks as base

REPLACEMENTS = {
 'gs': [
  ('finance commission versus gst council',
   'Match List I (institution) with List II (principal function).\nList I:\nP. Finance Commission\nQ. Election Commission of India\nR. Comptroller and Auditor General\nS. State Election Commission\nList II:\n1. Audit of public accounts\n2. Supervision of municipal and Panchayat elections\n3. Recommendations on Union-state tax devolution\n4. Supervision of parliamentary elections',
   ['P-3, Q-4, R-1, S-2','P-4, Q-3, R-1, S-2','P-3, Q-2, R-4, S-1','P-1, Q-4, R-2, S-3'], 'A',
   'The Finance Commission recommends fiscal devolution; ECI supervises parliamentary elections; CAG audits public accounts; State Election Commissions supervise local-body elections.'),
  ('lucknow pact significance',
   'Match List I (event) with List II (associated development).\nList I:\nP. Lucknow Pact, 1916\nQ. Poona Pact, 1932\nR. Cabinet Mission, 1946\nS. Lahore Congress session, 1929\nList II:\n1. Declaration of complete independence as the objective\n2. Congress-League constitutional agreement\n3. Reserved representation within joint electorates for Depressed Classes\n4. Proposed constitution-making framework and provincial grouping',
   ['P-2, Q-4, R-3, S-1','P-2, Q-3, R-4, S-1','P-1, Q-3, R-2, S-4','P-3, Q-2, R-4, S-1'], 'B',
   'Lucknow marked Congress-League agreement; Poona replaced separate electorates with reserved seats in joint electorates; the Cabinet Mission proposed a constitutional framework; Lahore adopted complete independence as the objective.'),
  ('pochampally technique',
   'Match List I (Telangana cultural tradition) with List II (characteristic).\nList I:\nP. Pochampally ikat\nQ. Cheriyal painting\nR. Perini Sivatandavam\nS. Bathukamma\nList II:\n1. Narrative scroll painting\n2. Floral arrangements central to festival observance\n3. Resist-dyed yarns arranged during weaving\n4. Vigorous dance associated with the Kakatiya martial tradition',
   ['P-1, Q-3, R-4, S-2','P-3, Q-1, R-2, S-4','P-3, Q-1, R-4, S-2','P-4, Q-2, R-3, S-1'], 'C',
   'Ikat patterns use resist-dyed yarns; Cheriyal scrolls support storytelling; Perini has a Kakatiya martial association; Bathukamma centres on floral arrangements.'),
 ],
 'civil': [
  ('energy theorem restrictions',
   'Match List I (structural analysis approach) with List II (associated principle).\nList I:\nP. Force method\nQ. Direct stiffness method\nR. Unit-load method\nS. Muller-Breslau principle\nList II:\n1. Qualitative influence line from release of the conjugate restraint\n2. Compatibility equations for redundant forces\n3. Displacement from products of real and virtual internal actions\n4. Nodal equilibrium equations in displacement unknowns',
   ['P-2, Q-4, R-3, S-1','P-4, Q-2, R-3, S-1','P-2, Q-3, R-4, S-1','P-3, Q-4, R-1, S-2'], 'A',
   'The force method solves compatibility for redundants; stiffness solves equilibrium for nodal displacements; unit-load work gives displacement; Muller-Breslau constructs influence-line shapes by a corresponding release.'),
  ('spillway routing peak lag',
   'Match List I (hydrological analysis) with List II (principal basis).\nList I:\nP. Level-pool reservoir routing\nQ. Muskingum channel routing\nR. Gumbel frequency analysis\nS. Double-mass rainfall analysis\nList II:\n1. Consistency assessment by cumulative rainfall comparison\n2. Extreme-value model for design-event magnitude\n3. Continuity combined with a storage-outflow relation\n4. Storage related to weighted inflow and outflow',
   ['P-4, Q-3, R-2, S-1','P-3, Q-4, R-2, S-1','P-3, Q-2, R-4, S-1','P-2, Q-4, R-1, S-3'], 'B',
   'Level-pool routing combines continuity with storage/outflow relationships; Muskingum uses weighted inflow and outflow in its storage model; Gumbel estimates extremes; double-mass analysis checks consistency.'),
  ('bitumen temperature susceptibility',
   'Match List I (material behaviour) with List II (engineering consequence).\nList I:\nP. Alkali-silica reaction\nQ. Carbonation of reinforced concrete\nR. Excessive shotcrete rebound reused without control\nS. Timber shrinkage anisotropy\nList II:\n1. Changed grading and paste proportion in the placed mix\n2. Different movement along radial and tangential directions\n3. Potential expansive reaction involving reactive aggregate, alkalis and moisture\n4. Reduced alkalinity that can compromise steel passivation',
   ['P-4, Q-3, R-1, S-2','P-3, Q-4, R-2, S-1','P-3, Q-4, R-1, S-2','P-1, Q-2, R-3, S-4'], 'C',
   'ASR can cause expansion; carbonation lowers alkalinity and can depassivate reinforcement; uncontrolled rebound alters shotcrete composition; timber movement depends on grain direction.'),
 ],
}


def main():
    sql_parts=[]
    notes=['# Matching-question revision', '',
           'Three matching items per paper replace three existing items; each paper retains its original title and 150 questions.',
           'Run `supabase/seeds/tgpsc_aee_2026_matching_revision.sql` after the original seeds.',
           'This updates the three questions in place only when the mock has no attempts; unchanged reruns are safe.',
           'No additional edition or title tag is created.',
           'The existing quality-report limitations still apply.', '']
    for kind, replacements in REPLACEMENTS.items():
        rows=json.loads((base.DATA/f'aee_2026_{kind}_questions.json').read_text(encoding='utf-8'))
        original_title,branch,marks=base.CONFIG[kind]
        title=original_title
        for topic,text,choices,key,explanation in replacements:
            row=next(r for r in rows if r['topic']==topic)
            row.update(question_text=text,options=[dict(value=v,text=t) for v,t in zip('ABCD',choices)],
                       correct_answer=key,explanation=explanation,style='matching',numerical_validation='not applicable')
            notes.append(f"- {kind.upper()} question {row['number']}: {key}; {row['subject']}.")
        base.CONFIG[kind]=(title,branch,marks)
        sql=base.seed(kind,rows)
        # Shared unchanged items across editions are intentional, not novel-question claims.
        start=sql.index('  -- Live exact-text guard.')
        end=sql.index('  INSERT INTO public.mock_questions',start)
        sql=sql[:start]+sql[end:]
        sql=sql.replace('0,FALSE) RETURNING id INTO v_test;', '0,TRUE) RETURNING id INTO v_test;')
        sql=sql.replace('Unpublished pending independent content review.', 'Practice paper with three matching questions; independent content review remains pending.')
        orders = ','.join(str(next(r['number'] for r in rows if r['topic']==topic)) for topic,*_ in replacements)
        update = f""" ELSE
+  IF EXISTS(SELECT 1 FROM public.mock_questions e JOIN jsonb_to_recordset(v_seed)
+    AS q(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT)
+    ON e.display_order=q.display_order WHERE e.mock_test_id=v_test
+    AND e.display_order IN ({orders}) AND
+    (e.question_text IS DISTINCT FROM q.question_text OR e.options IS DISTINCT FROM q.options
+     OR e.correct_answer IS DISTINCT FROM q.correct_answer OR e.explanation IS DISTINCT FROM q.explanation)) THEN
+   IF EXISTS(SELECT 1 FROM public.mock_attempts WHERE mock_test_id=v_test) THEN
+    RAISE EXCEPTION 'Cannot replace questions on a test with attempts; existing answers and scores must be preserved';
+   END IF;
+   UPDATE public.mock_questions e SET question_text=q.question_text,options=q.options,
+    correct_answer=q.correct_answer,explanation=q.explanation
+   FROM jsonb_to_recordset(v_seed) AS q(display_order INT,question_text TEXT,options JSONB,correct_answer TEXT,explanation TEXT)
+   WHERE e.mock_test_id=v_test AND e.display_order=q.display_order AND e.display_order IN ({orders});
+  END IF;
+  IF EXISTS""".replace('\n+', '\n')
        sql=sql.replace(' ELSE\n  IF EXISTS',update,1)
        sql_parts.append(sql.replace('BEGIN;\n','',1).removesuffix('COMMIT;\n'))
        (base.DATA/f'aee_2026_{kind}_matching_questions.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    (base.SEEDS/'tgpsc_aee_2026_matching_revision.sql').write_text('-- Original titles retained: TWO papers, 150 questions each, three matching items each.\nBEGIN;\nLOCK TABLE public.mock_attempts IN SHARE MODE;\n'+'\n'.join(sql_parts)+'\nCOMMIT;\n',encoding='utf-8')
    (base.DOCS/'tgpsc_aee_2026_matching_revision.md').write_text('\n'.join(notes)+'\n',encoding='utf-8')


if __name__=='__main__': main()
