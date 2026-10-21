-- SSC CGL Tier-I 2026 - Full Length Mock 01.
-- Prerequisite: public UUID mock schema from supabase/mock_test_setup.sql.
-- For online sectional enforcement, install supabase/ssc_cgl_section_timing.sql separately.
-- New test is UNPUBLISHED. Known wording corrections preserve IDs, keys and attempts.
-- Contains answers and explanations: run in trusted Supabase SQL Editor only.
-- JSON companion: supabase/data/ssc_cgl_tier1_mock_01.json.
BEGIN;
ALTER TABLE public.mock_questions ADD COLUMN IF NOT EXISTS explanation TEXT;
-- Apply only the known wording corrections to an already imported copy.
-- Keys, marks, IDs, answers and attempt history remain unchanged.
DO $wording$
DECLARE
 v_changes JSONB := $changes$[
  {
    "before": {
      "id": "9d56e537-cab9-5942-a3eb-c26674c356dc",
      "display_order": 3,
      "question_text": "[General Intelligence and Reasoning] Three pairs share the same ratio of second number to first number. Select the different pair.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "12, 30"
        },
        {
          "value": "2",
          "text": "18, 45"
        },
        {
          "value": "3",
          "text": "26, 65"
        },
        {
          "value": "4",
          "text": "34, 81"
        }
      ],
      "correct_answer": "4",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The ratios are 2.5 for (12,30), (18,45) and (26,65); 81/34 is not 2.5."
    },
    "after": {
      "id": "9d56e537-cab9-5942-a3eb-c26674c356dc",
      "display_order": 3,
      "question_text": "[General Intelligence and Reasoning] Select the number pair that is different from the other three.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "12, 30"
        },
        {
          "value": "2",
          "text": "18, 45"
        },
        {
          "value": "3",
          "text": "26, 65"
        },
        {
          "value": "4",
          "text": "34, 81"
        }
      ],
      "correct_answer": "4",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The ratios are 2.5 for (12,30), (18,45) and (26,65); 81/34 is not 2.5."
    }
  },
  {
    "before": {
      "id": "5e6bbb92-31aa-5195-a3a7-d7f2d9168378",
      "display_order": 5,
      "question_text": "[General Intelligence and Reasoning] Each term is twice the preceding term plus one. Find the missing term: 6, 13, 27, 55, 111, __.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "221"
        },
        {
          "value": "2",
          "text": "223"
        },
        {
          "value": "3",
          "text": "222"
        },
        {
          "value": "4",
          "text": "224"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "111 multiplied by two plus one is 223."
    },
    "after": {
      "id": "5e6bbb92-31aa-5195-a3a7-d7f2d9168378",
      "display_order": 5,
      "question_text": "[General Intelligence and Reasoning] Select the number that completes the series: 6, 13, 27, 55, 111, __.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "221"
        },
        {
          "value": "2",
          "text": "223"
        },
        {
          "value": "3",
          "text": "222"
        },
        {
          "value": "4",
          "text": "224"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "111 multiplied by two plus one is 223."
    }
  },
  {
    "before": {
      "id": "bdbc89df-d8a4-5e53-ac3e-627dc378a113",
      "display_order": 6,
      "question_text": "[General Intelligence and Reasoning] Complete the series using the successive-difference pattern: 4, 9, 19, 36, 62, 99, __.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "136"
        },
        {
          "value": "2",
          "text": "150"
        },
        {
          "value": "3",
          "text": "149"
        },
        {
          "value": "4",
          "text": "148"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The differences are 5,10,17,26,37. The next is 7^2+1=50, so the next term is 149."
    },
    "after": {
      "id": "bdbc89df-d8a4-5e53-ac3e-627dc378a113",
      "display_order": 6,
      "question_text": "[General Intelligence and Reasoning] Select the number that completes the series: 4, 9, 19, 36, 62, 99, __.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "136"
        },
        {
          "value": "2",
          "text": "150"
        },
        {
          "value": "3",
          "text": "149"
        },
        {
          "value": "4",
          "text": "148"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The differences are 5,10,17,26,37. The next is 7^2+1=50, so the next term is 149."
    }
  },
  {
    "before": {
      "id": "fdc4e4e6-c51b-5ca9-95b4-ae6b34e98ad3",
      "display_order": 7,
      "question_text": "[General Intelligence and Reasoning] In the sequence AZ, CX, FU, JQ, __, the first letters advance by 2, 3, 4, 5 positions, while the second letters retreat by those amounts. Find the missing pair.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "PK"
        },
        {
          "value": "2",
          "text": "OM"
        },
        {
          "value": "3",
          "text": "NL"
        },
        {
          "value": "4",
          "text": "OL"
        }
      ],
      "correct_answer": "4",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "J advances five places to O, and Q retreats five places to L. The missing pair is OL."
    },
    "after": {
      "id": "fdc4e4e6-c51b-5ca9-95b4-ae6b34e98ad3",
      "display_order": 7,
      "question_text": "[General Intelligence and Reasoning] Select the letter pair that completes the series: AZ, CX, FU, JQ, __.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "PK"
        },
        {
          "value": "2",
          "text": "OM"
        },
        {
          "value": "3",
          "text": "NL"
        },
        {
          "value": "4",
          "text": "OL"
        }
      ],
      "correct_answer": "4",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "J advances five places to O, and Q retreats five places to L. The missing pair is OL."
    }
  },
  {
    "before": {
      "id": "6ccedf2e-e893-5079-8da4-053777f81166",
      "display_order": 8,
      "question_text": "[General Intelligence and Reasoning] Reverse a word, then advance its first, second, third and fourth letters by 1, 2, 3 and 4 positions respectively. Thus MINT becomes UPLQ. How is FORK coded?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "LTSJ"
        },
        {
          "value": "2",
          "text": "LTRJ"
        },
        {
          "value": "3",
          "text": "LTQI"
        },
        {
          "value": "4",
          "text": "KTRJ"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "FORK reversed is KROF. Applying shifts +1,+2,+3,+4 gives L,T,R,J."
    },
    "after": {
      "id": "6ccedf2e-e893-5079-8da4-053777f81166",
      "display_order": 8,
      "question_text": "[General Intelligence and Reasoning] In a certain code language, MINT is written as UPLQ and PARK is written as LTDT. How is FORK written in that language?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "LTSJ"
        },
        {
          "value": "2",
          "text": "LTRJ"
        },
        {
          "value": "3",
          "text": "LTQI"
        },
        {
          "value": "4",
          "text": "KTRJ"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "FORK reversed is KROF. Applying shifts +1,+2,+3,+4 gives L,T,R,J."
    }
  },
  {
    "before": {
      "id": "1b568ece-42f2-5658-b460-81dc80b08d6d",
      "display_order": 10,
      "question_text": "[General Intelligence and Reasoning] In a code, letters in odd positions advance two places and letters in even positions retreat one place. Thus BRAVE becomes DQCUG. What is the code for STONE?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "USQMG"
        },
        {
          "value": "2",
          "text": "USQNF"
        },
        {
          "value": "3",
          "text": "URQMG"
        },
        {
          "value": "4",
          "text": "USPMG"
        }
      ],
      "correct_answer": "1",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "S+2=U, T-1=S, O+2=Q, N-1=M, E+2=G."
    },
    "after": {
      "id": "1b568ece-42f2-5658-b460-81dc80b08d6d",
      "display_order": 10,
      "question_text": "[General Intelligence and Reasoning] In a certain code language, BRAVE is written as DQCUG and PLANT is written as RKCMV. How is STONE written in that language?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "USQMG"
        },
        {
          "value": "2",
          "text": "USQNF"
        },
        {
          "value": "3",
          "text": "URQMG"
        },
        {
          "value": "4",
          "text": "USPMG"
        }
      ],
      "correct_answer": "1",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "S+2=U, T-1=S, O+2=Q, N-1=M, E+2=G."
    }
  },
  {
    "before": {
      "id": "3e970364-af69-56ae-988d-82e643f40e13",
      "display_order": 24,
      "question_text": "[General Intelligence and Reasoning] In the 2 x 2 matrix, moving right changes an outline shape to a filled shape; moving down changes a triangle to a square. Which numbered option completes the matrix?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Figure 3",
          "question_image": {
            "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMzE3IiB2aWV3Qm94PSIwIDAgNTIwIDMxNyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5JbiB0aGUgMiB4IDIgbWF0cml4LCBtb3ZpbmcgcmlnaHQgY2hhbmdlcyBhbiBvdXRsaW5lIHNoYXBlIHRvIGEgZmlsbGVkPC90ZXh0Pjx0ZXh0IHg9IjEyIiB5PSI0MCIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiIGZpbGw9IiMxNzI1NTQiPnNoYXBlOyBtb3ZpbmcgZG93biBjaGFuZ2VzIGEgdHJpYW5nbGUgdG8gYSBzcXVhcmUuIFdoaWNoIG51bWJlcmVkPC90ZXh0Pjx0ZXh0IHg9IjEyIiB5PSI2MCIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiIGZpbGw9IiMxNzI1NTQiPm9wdGlvbiBjb21wbGV0ZXMgdGhlIG1hdHJpeD88L3RleHQ+PGcgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCA3MikiPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbGw9IndoaXRlIi8+PGcgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMTcyNTU0IiBzdHJva2Utd2lkdGg9IjMiIHN0cm9rZS1saW5lam9pbj0icm91bmQiPjx0ZXh0IHg9IjIwIiB5PSIyMCIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+Q29tcGxldGUgdGhlIDIgeCAyIG1hdHJpeDwvdGV4dD48cGF0aCBkPSJNNDAgNzUgTDYwIDM1IEw4MCA3NSBaIi8+PHBhdGggZD0iTTE0MCA3NSBMMTYwIDM1IEwxODAgNzUgWiIgZmlsbD0iIzE3MjU1NCIvPjxyZWN0IHg9IjQwIiB5PSI5NSIgd2lkdGg9IjQwIiBoZWlnaHQ9IjQwIi8+PHRleHQgeD0iMTU1IiB5PSIxMjUiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPj88L3RleHQ+PHJlY3QgeD0iMjUiIHk9IjE3NSIgd2lkdGg9IjQwIiBoZWlnaHQ9IjQwIiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMjAiIHk9IjI0MCIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDE8L3RleHQ+PHBhdGggZD0iTTE1NSAyMTUgTDE3NSAxNzUgTDE5NSAyMTUgWiIgZmlsbD0iIzE3MjU1NCIvPjx0ZXh0IHg9IjE1MCIgeT0iMjQwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMjwvdGV4dD48cGF0aCBkPSJNMjg1IDIxNSBMMzA1IDE3NSBMMzI1IDIxNSBaIiBmaWxsPSJub25lIi8+PHRleHQgeD0iMjgwIiB5PSIyNDAiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAzPC90ZXh0PjxyZWN0IHg9IjQxNSIgeT0iMTc1IiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIGZpbGw9Im5vbmUiLz48dGV4dCB4PSI0MTAiIHk9IjI0MCIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDQ8L3RleHQ+PC9nPjwvZz48L3N2Zz4=",
            "alt": "Question 24: In the 2 x 2 matrix, moving right changes an outline shape to a filled shape; moving down changes a triangle to a square. Which numbered option completes the matrix?",
            "replaces_text": true
          }
        },
        {
          "value": "2",
          "text": "Figure 4"
        },
        {
          "value": "3",
          "text": "Figure 1"
        },
        {
          "value": "4",
          "text": "Figure 2"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "Apply both independent attributes: the bottom-right entry is a filled square."
    },
    "after": {
      "id": "3e970364-af69-56ae-988d-82e643f40e13",
      "display_order": 24,
      "question_text": "[General Intelligence and Reasoning] Select the numbered figure that completes the matrix.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Figure 3",
          "question_image": {
            "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMjc3IiB2aWV3Qm94PSIwIDAgNTIwIDI3NyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5TZWxlY3QgdGhlIG51bWJlcmVkIGZpZ3VyZSB0aGF0IGNvbXBsZXRlcyB0aGUgbWF0cml4LjwvdGV4dD48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDMyKSI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48ZyBmaWxsPSJub25lIiBzdHJva2U9IiMxNzI1NTQiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCI+PHRleHQgeD0iMjAiIHk9IjIwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5Db21wbGV0ZSB0aGUgMiB4IDIgbWF0cml4PC90ZXh0PjxwYXRoIGQ9Ik00MCA3NSBMNjAgMzUgTDgwIDc1IFoiLz48cGF0aCBkPSJNMTQwIDc1IEwxNjAgMzUgTDE4MCA3NSBaIiBmaWxsPSIjMTcyNTU0Ii8+PHJlY3QgeD0iNDAiIHk9Ijk1IiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiLz48dGV4dCB4PSIxNTUiIHk9IjEyNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+PzwvdGV4dD48cmVjdCB4PSIyNSIgeT0iMTc1IiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSIyMCIgeT0iMjQwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMTwvdGV4dD48cGF0aCBkPSJNMTU1IDIxNSBMMTc1IDE3NSBMMTk1IDIxNSBaIiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMTUwIiB5PSIyNDAiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAyPC90ZXh0PjxwYXRoIGQ9Ik0yODUgMjE1IEwzMDUgMTc1IEwzMjUgMjE1IFoiIGZpbGw9Im5vbmUiLz48dGV4dCB4PSIyODAiIHk9IjI0MCIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDM8L3RleHQ+PHJlY3QgeD0iNDE1IiB5PSIxNzUiIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgZmlsbD0ibm9uZSIvPjx0ZXh0IHg9IjQxMCIgeT0iMjQwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgNDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==",
            "alt": "Question 24: Select the numbered figure that completes the matrix.",
            "replaces_text": true
          }
        },
        {
          "value": "2",
          "text": "Figure 4"
        },
        {
          "value": "3",
          "text": "Figure 1"
        },
        {
          "value": "4",
          "text": "Figure 2"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "Apply both independent attributes: the bottom-right entry is a filled square."
    }
  },
  {
    "before": {
      "id": "0458ae53-9494-52d7-957b-8d8a67ba1eff",
      "display_order": 88,
      "question_text": "[English Comprehension] Which revision removes the dangling modifier in 'Having inspected the bridge, several cracks were recorded in the report'?",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Having inspected the bridge, the report recorded several cracks"
        },
        {
          "value": "2",
          "text": "Having inspected the bridge, there were several cracks in the report"
        },
        {
          "value": "3",
          "text": "Having inspected the bridge, the engineers recorded several cracks in the report"
        },
        {
          "value": "4",
          "text": "Having inspected the bridge, several cracks had appeared in the report"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The subject following the introductory participial clause must be the inspecting agent. Only 'the engineers' can perform the inspection."
    },
    "after": {
      "id": "0458ae53-9494-52d7-957b-8d8a67ba1eff",
      "display_order": 88,
      "question_text": "[English Comprehension] Select the grammatically correct sentence.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Having inspected the bridge, the report recorded several cracks"
        },
        {
          "value": "2",
          "text": "Having inspected the bridge, there were several cracks in the report"
        },
        {
          "value": "3",
          "text": "Having inspected the bridge, the engineers recorded several cracks in the report"
        },
        {
          "value": "4",
          "text": "Having inspected the bridge, several cracks had appeared in the report"
        }
      ],
      "correct_answer": "3",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The subject following the introductory participial clause must be the inspecting agent. Only 'the engineers' can perform the inspection."
    }
  },
  {
    "before": {
      "id": "7d9fae53-ed81-58bf-8537-382d7fa60a0f",
      "display_order": 89,
      "question_text": "[English Comprehension] Choose the sentence with a logically and grammatically parallel comparison.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Implementing the revised plan costs less than the original plan itself"
        },
        {
          "value": "2",
          "text": "The revised plan is more economical to implement than the original plan was"
        },
        {
          "value": "3",
          "text": "The revised plan's implementation cost is lower than implementing the original plan"
        },
        {
          "value": "4",
          "text": "The cost of implementing the revised plan is lower than the original plan"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The correct option compares plans in the same respect, with 'was' supplying the parallel predicate. The alternatives compare a cost or activity with an unlike object."
    },
    "after": {
      "id": "7d9fae53-ed81-58bf-8537-382d7fa60a0f",
      "display_order": 89,
      "question_text": "[English Comprehension] Select the grammatically correct sentence.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Implementing the revised plan costs less than the original plan itself"
        },
        {
          "value": "2",
          "text": "The revised plan is more economical to implement than the original plan was"
        },
        {
          "value": "3",
          "text": "The revised plan's implementation cost is lower than implementing the original plan"
        },
        {
          "value": "4",
          "text": "The cost of implementing the revised plan is lower than the original plan"
        }
      ],
      "correct_answer": "2",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "The correct option compares plans in the same respect, with 'was' supplying the parallel predicate. The alternatives compare a cost or activity with an unlike object."
    }
  },
  {
    "before": {
      "id": "96f9d010-8fef-514c-b7ba-d08582888353",
      "display_order": 98,
      "question_text": "[English Comprehension] On Friday, Leela said, 'I will submit the revised draft tomorrow.' Report this on Sunday using ordinary tense backshift and preserving the intended submission day.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Leela said that she would submit the revised draft the following day"
        },
        {
          "value": "2",
          "text": "Leela said that she would have submitted the revised draft yesterday"
        },
        {
          "value": "3",
          "text": "Leela said that she had submitted the revised draft the previous day"
        },
        {
          "value": "4",
          "text": "Leela said that she will submit the revised draft tomorrow"
        }
      ],
      "correct_answer": "1",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "In ordinary reported speech, will becomes would and tomorrow becomes the following day. The original promise concerned Saturday; do not turn a promise into a completed action."
    },
    "after": {
      "id": "96f9d010-8fef-514c-b7ba-d08582888353",
      "display_order": 98,
      "question_text": "[English Comprehension] On Friday, Leela said, 'I will submit the revised draft tomorrow.' Choose the correct reported form of her statement when reporting it on Sunday.",
      "question_type": "mcq",
      "options": [
        {
          "value": "1",
          "text": "Leela said that she would submit the revised draft the following day"
        },
        {
          "value": "2",
          "text": "Leela said that she would have submitted the revised draft yesterday"
        },
        {
          "value": "3",
          "text": "Leela said that she had submitted the revised draft the previous day"
        },
        {
          "value": "4",
          "text": "Leela said that she will submit the revised draft tomorrow"
        }
      ],
      "correct_answer": "1",
      "marks": 2,
      "negative_marks": 0.5,
      "explanation": "In ordinary reported speech, will becomes would and tomorrow becomes the following day. The original promise concerned Saturday; do not turn a promise into a completed action."
    }
  }
]$changes$::JSONB;
 v_change JSONB;
 v_current JSONB;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext('SSC CGL Tier-I 2026 - Full Length Mock 01')::BIGINT);
 FOR v_change IN SELECT value FROM jsonb_array_elements(v_changes) LOOP
  SELECT jsonb_build_object('id',q.id,'display_order',q.display_order,
   'question_text',q.question_text,'question_type',q.question_type,'options',q.options,
   'correct_answer',q.correct_answer,'marks',q.marks,'negative_marks',q.negative_marks,'explanation',q.explanation)
  INTO v_current FROM public.mock_questions q
  WHERE q.mock_test_id='7a9cd0bf-bfa9-5ae1-9b7b-2e6a1d82e55a'::UUID
   AND q.id=(v_change->'before'->>'id')::UUID FOR UPDATE;
  IF NOT FOUND THEN CONTINUE; END IF;
  IF v_current = v_change->'before' THEN
   UPDATE public.mock_questions SET question_text=v_change->'after'->>'question_text',options=v_change->'after'->'options'
   WHERE id=(v_change->'before'->>'id')::UUID AND mock_test_id='7a9cd0bf-bfa9-5ae1-9b7b-2e6a1d82e55a'::UUID;
  ELSIF v_current IS DISTINCT FROM v_change->'after' THEN
   RAISE EXCEPTION 'Question % differs from the known wording versions; refusing to overwrite',v_change->'before'->>'display_order';
  END IF;
 END LOOP;
END;
$wording$;
DO $seed$
DECLARE
 v_title TEXT := 'SSC CGL Tier-I 2026 - Full Length Mock 01';
 v_legacy_title TEXT := 'SSC CGL Tier-I 2026 - Full Length Mock 01 (DI 70)';
 v_test UUID := '7a9cd0bf-bfa9-5ae1-9b7b-2e6a1d82e55a';
 v_description TEXT := $description$Original unofficial English challenge practice. 100 questions, four sections of 25, 60 minutes, +2 correct / -0.50 wrong. Editorial DI 70; not empirically calibrated. Includes original passages and inline diagrams. No official qualifying cutoff is asserted. Unpublished review draft.$description$;
 v_payload JSONB := $questions$[
  {
    "id": "867f0f9f-08e7-5362-9cd6-6ab253b861f4",
    "display_order": 1,
    "question_text": "[General Intelligence and Reasoning] Apply the same rule to both pairs: 5 : 126, 7 : 344, 9 : ?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "728"
      },
      {
        "value": "2",
        "text": "729"
      },
      {
        "value": "3",
        "text": "730"
      },
      {
        "value": "4",
        "text": "820"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The output is the cube of the input plus one: 5^3+1=126 and 7^3+1=344, so 9^3+1=730."
  },
  {
    "id": "0a8524db-6eda-532d-97a3-1a246234b13e",
    "display_order": 2,
    "question_text": "[General Intelligence and Reasoning] Choose the pair that shows the same relationship as 'opaque : transparent'.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Scarce : abundant"
      },
      {
        "value": "2",
        "text": "Fragile : brittle"
      },
      {
        "value": "3",
        "text": "Rapid : swift"
      },
      {
        "value": "4",
        "text": "Cautious : prudent"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Opaque and transparent are opposites. Scarce and abundant are also opposites; each other pair consists of near-synonyms."
  },
  {
    "id": "9d56e537-cab9-5942-a3eb-c26674c356dc",
    "display_order": 3,
    "question_text": "[General Intelligence and Reasoning] Select the number pair that is different from the other three.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "12, 30"
      },
      {
        "value": "2",
        "text": "18, 45"
      },
      {
        "value": "3",
        "text": "26, 65"
      },
      {
        "value": "4",
        "text": "34, 81"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The ratios are 2.5 for (12,30), (18,45) and (26,65); 81/34 is not 2.5."
  },
  {
    "id": "7eec8106-7722-54aa-9dd7-815ff17790ce",
    "display_order": 4,
    "question_text": "[General Intelligence and Reasoning] Arrange these words in dictionary order: 1. tractable 2. trajectory 3. traditional 4. transaction. Which sequence is correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "1-3-4-2"
      },
      {
        "value": "2",
        "text": "3-1-2-4"
      },
      {
        "value": "3",
        "text": "1-2-3-4"
      },
      {
        "value": "4",
        "text": "1-3-2-4"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "After 'tra', c precedes d, which precedes j, which precedes n: tractable, traditional, trajectory, transaction."
  },
  {
    "id": "5e6bbb92-31aa-5195-a3a7-d7f2d9168378",
    "display_order": 5,
    "question_text": "[General Intelligence and Reasoning] Select the number that completes the series: 6, 13, 27, 55, 111, __.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "221"
      },
      {
        "value": "2",
        "text": "223"
      },
      {
        "value": "3",
        "text": "222"
      },
      {
        "value": "4",
        "text": "224"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "111 multiplied by two plus one is 223."
  },
  {
    "id": "bdbc89df-d8a4-5e53-ac3e-627dc378a113",
    "display_order": 6,
    "question_text": "[General Intelligence and Reasoning] Select the number that completes the series: 4, 9, 19, 36, 62, 99, __.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "136"
      },
      {
        "value": "2",
        "text": "150"
      },
      {
        "value": "3",
        "text": "149"
      },
      {
        "value": "4",
        "text": "148"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The differences are 5,10,17,26,37. The next is 7^2+1=50, so the next term is 149."
  },
  {
    "id": "fdc4e4e6-c51b-5ca9-95b4-ae6b34e98ad3",
    "display_order": 7,
    "question_text": "[General Intelligence and Reasoning] Select the letter pair that completes the series: AZ, CX, FU, JQ, __.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "PK"
      },
      {
        "value": "2",
        "text": "OM"
      },
      {
        "value": "3",
        "text": "NL"
      },
      {
        "value": "4",
        "text": "OL"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "J advances five places to O, and Q retreats five places to L. The missing pair is OL."
  },
  {
    "id": "6ccedf2e-e893-5079-8da4-053777f81166",
    "display_order": 8,
    "question_text": "[General Intelligence and Reasoning] In a certain code language, MINT is written as UPLQ and PARK is written as LTDT. How is FORK written in that language?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "LTSJ"
      },
      {
        "value": "2",
        "text": "LTRJ"
      },
      {
        "value": "3",
        "text": "LTQI"
      },
      {
        "value": "4",
        "text": "KTRJ"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "FORK reversed is KROF. Applying shifts +1,+2,+3,+4 gives L,T,R,J."
  },
  {
    "id": "8516bea0-7a04-5903-9ff5-f6a5f6c5b8c9",
    "display_order": 9,
    "question_text": "[General Intelligence and Reasoning] In a code, 'red small box' is 'ka mi to', 'red heavy bag' is 'mi su pa', and 'blue heavy box' is 'to su ne'. Word order is not preserved. Which two codes mean 'bag blue', in any order?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "pa su"
      },
      {
        "value": "2",
        "text": "pa ne"
      },
      {
        "value": "3",
        "text": "ka ne"
      },
      {
        "value": "4",
        "text": "mi ne"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The shared words establish red=mi, heavy=su and box=to. Hence small=ka, bag=pa and blue=ne."
  },
  {
    "id": "1b568ece-42f2-5658-b460-81dc80b08d6d",
    "display_order": 10,
    "question_text": "[General Intelligence and Reasoning] In a certain code language, BRAVE is written as DQCUG and PLANT is written as RKCMV. How is STONE written in that language?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "USQMG"
      },
      {
        "value": "2",
        "text": "USQNF"
      },
      {
        "value": "3",
        "text": "URQMG"
      },
      {
        "value": "4",
        "text": "USPMG"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "S+2=U, T-1=S, O+2=Q, N-1=M, E+2=G."
  },
  {
    "id": "2bd2446b-5c44-5761-b447-a8c2e47bf155",
    "display_order": 11,
    "question_text": "[General Intelligence and Reasoning] All siblings mentioned are full siblings. A is B's mother. B is C's brother. C is D's wife, and C and D are E's parents. How is A related to E?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Maternal grandmother"
      },
      {
        "value": "2",
        "text": "Paternal grandmother"
      },
      {
        "value": "3",
        "text": "Maternal aunt"
      },
      {
        "value": "4",
        "text": "Paternal aunt"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "A is also C's mother because B and C are full siblings. C is E's mother, making A the maternal grandmother."
  },
  {
    "id": "ab1a49e5-18d7-5b44-aa6b-724c14ef6780",
    "display_order": 12,
    "question_text": "[General Intelligence and Reasoning] Two teams start at O. Team A finishes 8 km north and 6 km east of O; team B finishes 3 km north and 2 km east of O. Where is B relative to A?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "South-east, sqrt(41) km away"
      },
      {
        "value": "2",
        "text": "South-west, sqrt(41) km away"
      },
      {
        "value": "3",
        "text": "North-east, sqrt(41) km away"
      },
      {
        "value": "4",
        "text": "South-west, 9 km away"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Subtract the final coordinates: B-A=(-4,-5). B is south-west of A, at distance sqrt(4^2+5^2)=sqrt(41) km."
  },
  {
    "id": "ba93dd44-d41e-514b-9e11-476d70ec211f",
    "display_order": 13,
    "question_text": "[General Intelligence and Reasoning] P is 17th from the left and Q is 11th from the right in a row. P is to the left of Q, with exactly five people between them. How many people are in the row?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "32"
      },
      {
        "value": "2",
        "text": "33"
      },
      {
        "value": "3",
        "text": "34"
      },
      {
        "value": "4",
        "text": "38"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Q is 17+5+1=23rd from the left. Total=23+11-1=33."
  },
  {
    "id": "851fd4cb-69c0-56dd-8f44-28afa2e649ae",
    "display_order": 14,
    "question_text": "[General Intelligence and Reasoning] Given A >= B > C = D < E and F <= D, which conclusions necessarily follow? I. A > F. II. E > A. III. B > D.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "I, II and III"
      },
      {
        "value": "2",
        "text": "II and III only"
      },
      {
        "value": "3",
        "text": "I only"
      },
      {
        "value": "4",
        "text": "I and III only"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "A >= B > D >= F proves I; B > C = D proves III. E and A have no fixed relative order, so II is not forced."
  },
  {
    "id": "94579741-c6e7-575f-b6b1-37b116b03239",
    "display_order": 15,
    "question_text": "[General Intelligence and Reasoning] Assume only these statements: All lamps are stones. Some stones are keys. No key is a wheel. Conclusions: I. Some stones are not wheels. II. Some lamps are keys. III. No lamp is a wheel. Which conclusions necessarily follow?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "I only"
      },
      {
        "value": "2",
        "text": "I and II only"
      },
      {
        "value": "3",
        "text": "I and III only"
      },
      {
        "value": "4",
        "text": "II and III only"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The stones that are keys cannot be wheels, proving I. Lamps need not overlap keys, and lamps outside the key set could be wheels; II and III do not follow."
  },
  {
    "id": "4338eb37-d2a1-5dad-bcb4-b478d1e698d6",
    "display_order": 16,
    "question_text": "[General Intelligence and Reasoning] Of 100 applicants, all know at least one of P, Q and R. The counts are P=60, Q=55, R=45; P and Q=30, Q and R=25, P and R=20, with pair counts including those knowing all three. Fifteen know all three. How many know exactly one?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "55"
      },
      {
        "value": "2",
        "text": "40"
      },
      {
        "value": "3",
        "text": "70"
      },
      {
        "value": "4",
        "text": "45"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Exactly-one count is 60+55+45-2(30+25+20)+3(15)=55. Inclusion-exclusion also gives a union of 100."
  },
  {
    "id": "810784b7-41af-5f0e-87f9-3152c1d1d7d0",
    "display_order": 17,
    "question_text": "[General Intelligence and Reasoning] Interchange the meanings of + and division, leaving other operations unchanged. Using normal precedence, evaluate 36 + 6 x 4 - 5.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "24"
      },
      {
        "value": "2",
        "text": "23"
      },
      {
        "value": "3",
        "text": "19"
      },
      {
        "value": "4",
        "text": "139"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The expression becomes 36/6 x 4-5=24-5=19."
  },
  {
    "id": "609a919b-e0f8-525b-a075-1dcf3cc540f4",
    "display_order": 18,
    "question_text": "[General Intelligence and Reasoning] Apply the same rule to every row and find the missing third entry: (4,7,65), (6,5,61), (8,3,?).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "73"
      },
      {
        "value": "2",
        "text": "121"
      },
      {
        "value": "3",
        "text": "64"
      },
      {
        "value": "4",
        "text": "79"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "8^2+3^2=64+9=73."
  },
  {
    "id": "69c53276-a365-548f-95b9-7e2107f04126",
    "display_order": 19,
    "question_text": "[General Intelligence and Reasoning] Seven people A-G sit in a row facing north. D is fourth to the left of G. B is immediately right of G. E is right of B. C is second to the right of A, and A is left of F. Who sits immediately left of C?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "D"
      },
      {
        "value": "2",
        "text": "F"
      },
      {
        "value": "3",
        "text": "G"
      },
      {
        "value": "4",
        "text": "A"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The unique left-to-right order is D,A,F,C,G,B,E. The two places after B and G force D at the left end; the remaining clues fix A,F,C."
  },
  {
    "id": "fd7a3739-e869-525a-9591-a519aa2aba28",
    "display_order": 20,
    "question_text": "[General Intelligence and Reasoning] Six distinct reports P,Q,R,S,T,U occupy six slots, one per slot. P must precede R; Q must immediately follow T; and S must precede U, which must precede R. How many different schedules satisfy all conditions?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "10"
      },
      {
        "value": "2",
        "text": "15"
      },
      {
        "value": "3",
        "text": "20"
      },
      {
        "value": "4",
        "text": "30"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Treat TQ as one block. Of the remaining P,S,U,R, R must be last and S before U, leaving 3 orders. Insert TQ into any of 5 positions: 3 x 5=15."
  },
  {
    "id": "bbabe557-4d81-5815-867a-a25b61e0fad7",
    "display_order": 21,
    "question_text": "[General Intelligence and Reasoning] The diagram shows a figure and a vertical mirror to its right. Which numbered option is its reflection? Select the corresponding figure number.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Figure 2",
        "question_image": {
          "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMzE3IiB2aWV3Qm94PSIwIDAgNTIwIDMxNyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5UaGUgZGlhZ3JhbSBzaG93cyBhIGZpZ3VyZSBhbmQgYSB2ZXJ0aWNhbCBtaXJyb3IgdG8gaXRzIHJpZ2h0LiBXaGljaDwvdGV4dD48dGV4dCB4PSIxMiIgeT0iNDAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5udW1iZXJlZCBvcHRpb24gaXMgaXRzIHJlZmxlY3Rpb24/IFNlbGVjdCB0aGUgY29ycmVzcG9uZGluZyBmaWd1cmU8L3RleHQ+PHRleHQgeD0iMTIiIHk9IjYwIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSIgZmlsbD0iIzE3MjU1NCI+bnVtYmVyLjwvdGV4dD48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDcyKSI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48ZyBmaWxsPSJub25lIiBzdHJva2U9IiMxNzI1NTQiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCI+PHRleHQgeD0iMjAiIHk9IjIyIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5HaXZlbiBmaWd1cmU8L3RleHQ+PHBvbHlsaW5lIHBvaW50cz0iNjUsOTAgNjUsNDAgMTA1LDQwIDEwNSw2MCAxMjAsNjAiLz48Y2lyY2xlIGN4PSI4MCIgY3k9Ijc3IiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHBhdGggZD0iTTE0MCAyNSBWMTA1IiBzdHJva2UtZGFzaGFycmF5PSI1IDMiLz48dGV4dCB4PSIxNTAiIHk9IjY1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5NaXJyb3I8L3RleHQ+PHBvbHlsaW5lIHBvaW50cz0iNDAsMTU1IDQwLDIwNSA4MCwyMDUgODAsMTg1IDk1LDE4NSIvPjxjaXJjbGUgY3g9IjU1IiBjeT0iMTY4IiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMzgiIHk9IjIzNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDE8L3RleHQ+PHBvbHlsaW5lIHBvaW50cz0iMjIwLDIwNSAyMjAsMTU1IDE4MCwxNTUgMTgwLDE3NSAxNjUsMTc1Ii8+PGNpcmNsZSBjeD0iMjA1IiBjeT0iMTkyIiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMTY4IiB5PSIyMzUiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAyPC90ZXh0Pjxwb2x5bGluZSBwb2ludHM9IjM1MCwyMDUgMzAwLDIwNSAzMDAsMTY1IDMyMCwxNjUgMzIwLDE1MCIvPjxjaXJjbGUgY3g9IjMzNyIgY3k9IjE5MCIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjx0ZXh0IHg9IjI5OCIgeT0iMjM1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMzwvdGV4dD48cG9seWxpbmUgcG9pbnRzPSI0MzAsMTU1IDQ4MCwxNTUgNDgwLDE5NSA0NjAsMTk1IDQ2MCwyMTAiLz48Y2lyY2xlIGN4PSI0NDMiIGN5PSIxNzAiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSI0MjgiIHk9IjIzNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDQ8L3RleHQ+PC9nPjwvZz48L3N2Zz4=",
          "alt": "Question 21: The diagram shows a figure and a vertical mirror to its right. Which numbered option is its reflection? Select the corresponding figure number.",
          "replaces_text": true
        }
      },
      {
        "value": "2",
        "text": "Figure 4"
      },
      {
        "value": "3",
        "text": "Figure 1"
      },
      {
        "value": "4",
        "text": "Figure 3"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "A vertical mirror reverses left and right without reversing up and down. Both the outline and the dot must reflect together."
  },
  {
    "id": "0aa1073e-2500-5c7a-b770-dbb24c89a72a",
    "display_order": 22,
    "question_text": "[General Intelligence and Reasoning] Which numbered option is obtained by rotating the entire given figure 90 degrees clockwise about its centre, without reflection?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Figure 4",
        "question_image": {
          "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMjk3IiB2aWV3Qm94PSIwIDAgNTIwIDI5NyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5XaGljaCBudW1iZXJlZCBvcHRpb24gaXMgb2J0YWluZWQgYnkgcm90YXRpbmcgdGhlIGVudGlyZSBnaXZlbiBmaWd1cmU8L3RleHQ+PHRleHQgeD0iMTIiIHk9IjQwIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSIgZmlsbD0iIzE3MjU1NCI+OTAgZGVncmVlcyBjbG9ja3dpc2UgYWJvdXQgaXRzIGNlbnRyZSwgd2l0aG91dCByZWZsZWN0aW9uPzwvdGV4dD48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDUyKSI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48ZyBmaWxsPSJub25lIiBzdHJva2U9IiMxNzI1NTQiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCI+PHRleHQgeD0iMjAiIHk9IjIyIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5HaXZlbiBmaWd1cmU8L3RleHQ+PHBvbHlsaW5lIHBvaW50cz0iNjUsOTAgNjUsNDAgMTA1LDQwIDEwNSw2MCAxMjAsNjAiLz48Y2lyY2xlIGN4PSI4MCIgY3k9Ijc3IiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHBvbHlsaW5lIHBvaW50cz0iOTAsMTU1IDkwLDIwNSA1MCwyMDUgNTAsMTg1IDM1LDE4NSIvPjxjaXJjbGUgY3g9Ijc1IiBjeT0iMTY4IiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMzgiIHk9IjIzNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDE8L3RleHQ+PHBvbHlsaW5lIHBvaW50cz0iMjIwLDIwNSAxNzAsMjA1IDE3MCwxNjUgMTkwLDE2NSAxOTAsMTUwIi8+PGNpcmNsZSBjeD0iMjA3IiBjeT0iMTkwIiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMTY4IiB5PSIyMzUiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAyPC90ZXh0Pjxwb2x5bGluZSBwb2ludHM9IjMwMCwxNTUgMzUwLDE1NSAzNTAsMTk1IDMzMCwxOTUgMzMwLDIxMCIvPjxjaXJjbGUgY3g9IjMxMyIgY3k9IjE3MCIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjx0ZXh0IHg9IjI5OCIgeT0iMjM1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMzwvdGV4dD48cG9seWxpbmUgcG9pbnRzPSI0ODAsMjA1IDQ4MCwxNTUgNDQwLDE1NSA0NDAsMTc1IDQyNSwxNzUiLz48Y2lyY2xlIGN4PSI0NjUiIGN5PSIxOTIiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSI0MjgiIHk9IjIzNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDQ8L3RleHQ+PC9nPjwvZz48L3N2Zz4=",
          "alt": "Question 22: Which numbered option is obtained by rotating the entire given figure 90 degrees clockwise about its centre, without reflection?",
          "replaces_text": true
        }
      },
      {
        "value": "2",
        "text": "Figure 2"
      },
      {
        "value": "3",
        "text": "Figure 3"
      },
      {
        "value": "4",
        "text": "Figure 1"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "For screen coordinates centred at the figure, a clockwise quarter turn maps (x,y) to (-y,x). Rotate the outline and the dot together."
  },
  {
    "id": "ef1d8aff-eecc-5761-88a5-da91affa6330",
    "display_order": 23,
    "question_text": "[General Intelligence and Reasoning] A square sheet is folded right-to-left and then bottom-to-top, leaving its top-left quarter. One small circular hole is punched away from both folds, as shown. Which numbered pattern appears on unfolding completely?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Figure 1",
        "question_image": {
          "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMzUyIiB2aWV3Qm94PSIwIDAgNTIwIDM1MiI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5BIHNxdWFyZSBzaGVldCBpcyBmb2xkZWQgcmlnaHQtdG8tbGVmdCBhbmQgdGhlbiBib3R0b20tdG8tdG9wLCBsZWF2aW5nPC90ZXh0Pjx0ZXh0IHg9IjEyIiB5PSI0MCIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiIGZpbGw9IiMxNzI1NTQiPml0cyB0b3AtbGVmdCBxdWFydGVyLiBPbmUgc21hbGwgY2lyY3VsYXIgaG9sZSBpcyBwdW5jaGVkIGF3YXkgZnJvbTwvdGV4dD48dGV4dCB4PSIxMiIgeT0iNjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5ib3RoIGZvbGRzLCBhcyBzaG93bi4gV2hpY2ggbnVtYmVyZWQgcGF0dGVybiBhcHBlYXJzIG9uIHVuZm9sZGluZzwvdGV4dD48dGV4dCB4PSIxMiIgeT0iODAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5jb21wbGV0ZWx5PzwvdGV4dD48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDkyKSI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48ZyBmaWxsPSJub25lIiBzdHJva2U9IiMxNzI1NTQiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCI+PHRleHQgeD0iMTAiIHk9IjIwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5Gb2xkIHJpZ2h0IHRvIGxlZnQsIHRoZW4gYm90dG9tIHRvIHRvcDsgcHVuY2ggYXQgdGhlIGRvdC48L3RleHQ+PHJlY3QgeD0iMjAiIHk9IjM1IiB3aWR0aD0iODAiIGhlaWdodD0iODAiLz48cGF0aCBkPSJNNjAgMzUgVjExNSBNMjAgNzUgSDEwMCIgc3Ryb2tlLWRhc2hhcnJheT0iNCAzIi8+PGNpcmNsZSBjeD0iMzgiIGN5PSI1MyIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjx0ZXh0IHg9IjEyMCIgeT0iNjUiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPlJldGFpbmVkIHF1YXJ0ZXI6IHRvcC1sZWZ0PC90ZXh0PjxyZWN0IHg9IjIwIiB5PSIxNDUiIHdpZHRoPSI4MCIgaGVpZ2h0PSI4MCIvPjxjaXJjbGUgY3g9IjM4IiBjeT0iMTYzIiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PGNpcmNsZSBjeD0iODIiIGN5PSIxNjMiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSIzMCIgeT0iMjQzIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMTwvdGV4dD48cmVjdCB4PSIxNTAiIHk9IjE0NSIgd2lkdGg9IjgwIiBoZWlnaHQ9IjgwIi8+PGNpcmNsZSBjeD0iMTY4IiBjeT0iMTYzIiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PGNpcmNsZSBjeD0iMTY4IiBjeT0iMjA3IiByPSI0IiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMTYwIiB5PSIyNDMiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAyPC90ZXh0PjxyZWN0IHg9IjI4MCIgeT0iMTQ1IiB3aWR0aD0iODAiIGhlaWdodD0iODAiLz48Y2lyY2xlIGN4PSIyOTgiIGN5PSIxNjMiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48Y2lyY2xlIGN4PSIzMjAiIGN5PSIxNjMiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48Y2lyY2xlIGN4PSIyOTgiIGN5PSIxODUiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48Y2lyY2xlIGN4PSIzMjAiIGN5PSIxODUiIHI9IjQiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSIyOTAiIHk9IjI0MyIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDM8L3RleHQ+PHJlY3QgeD0iNDEwIiB5PSIxNDUiIHdpZHRoPSI4MCIgaGVpZ2h0PSI4MCIvPjxjaXJjbGUgY3g9IjQyOCIgY3k9IjE2MyIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjxjaXJjbGUgY3g9IjQ3MiIgY3k9IjE2MyIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjxjaXJjbGUgY3g9IjQyOCIgY3k9IjIwNyIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjxjaXJjbGUgY3g9IjQ3MiIgY3k9IjIwNyIgcj0iNCIgZmlsbD0iIzE3MjU1NCIvPjx0ZXh0IHg9IjQyMCIgeT0iMjQzIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgNDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==",
          "alt": "Question 23: A square sheet is folded right-to-left and then bottom-to-top, leaving its top-left quarter. One small circular hole is punched away from both folds, as shown. Which numbered pattern appears on unfolding completely?",
          "replaces_text": true
        }
      },
      {
        "value": "2",
        "text": "Figure 3"
      },
      {
        "value": "3",
        "text": "Figure 2"
      },
      {
        "value": "4",
        "text": "Figure 4"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Reflect the punched point across the horizontal fold and then the vertical fold. Four holes occur at the four symmetric points, not on the fold axes."
  },
  {
    "id": "3e970364-af69-56ae-988d-82e643f40e13",
    "display_order": 24,
    "question_text": "[General Intelligence and Reasoning] Select the numbered figure that completes the matrix.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Figure 3",
        "question_image": {
          "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMjc3IiB2aWV3Qm94PSIwIDAgNTIwIDI3NyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5TZWxlY3QgdGhlIG51bWJlcmVkIGZpZ3VyZSB0aGF0IGNvbXBsZXRlcyB0aGUgbWF0cml4LjwvdGV4dD48ZyB0cmFuc2Zvcm09InRyYW5zbGF0ZSgwIDMyKSI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48ZyBmaWxsPSJub25lIiBzdHJva2U9IiMxNzI1NTQiIHN0cm9rZS13aWR0aD0iMyIgc3Ryb2tlLWxpbmVqb2luPSJyb3VuZCI+PHRleHQgeD0iMjAiIHk9IjIwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5Db21wbGV0ZSB0aGUgMiB4IDIgbWF0cml4PC90ZXh0PjxwYXRoIGQ9Ik00MCA3NSBMNjAgMzUgTDgwIDc1IFoiLz48cGF0aCBkPSJNMTQwIDc1IEwxNjAgMzUgTDE4MCA3NSBaIiBmaWxsPSIjMTcyNTU0Ii8+PHJlY3QgeD0iNDAiIHk9Ijk1IiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiLz48dGV4dCB4PSIxNTUiIHk9IjEyNSIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+PzwvdGV4dD48cmVjdCB4PSIyNSIgeT0iMTc1IiB3aWR0aD0iNDAiIGhlaWdodD0iNDAiIGZpbGw9IiMxNzI1NTQiLz48dGV4dCB4PSIyMCIgeT0iMjQwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgMTwvdGV4dD48cGF0aCBkPSJNMTU1IDIxNSBMMTc1IDE3NSBMMTk1IDIxNSBaIiBmaWxsPSIjMTcyNTU0Ii8+PHRleHQgeD0iMTUwIiB5PSIyNDAiIGZpbGw9IiMxNzI1NTQiIHN0cm9rZT0ibm9uZSIgZm9udC1mYW1pbHk9IkFyaWFsLHNhbnMtc2VyaWYiIGZvbnQtc2l6ZT0iMTUiPkZpZ3VyZSAyPC90ZXh0PjxwYXRoIGQ9Ik0yODUgMjE1IEwzMDUgMTc1IEwzMjUgMjE1IFoiIGZpbGw9Im5vbmUiLz48dGV4dCB4PSIyODAiIHk9IjI0MCIgZmlsbD0iIzE3MjU1NCIgc3Ryb2tlPSJub25lIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSI+RmlndXJlIDM8L3RleHQ+PHJlY3QgeD0iNDE1IiB5PSIxNzUiIHdpZHRoPSI0MCIgaGVpZ2h0PSI0MCIgZmlsbD0ibm9uZSIvPjx0ZXh0IHg9IjQxMCIgeT0iMjQwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GaWd1cmUgNDwvdGV4dD48L2c+PC9nPjwvc3ZnPg==",
          "alt": "Question 24: Select the numbered figure that completes the matrix.",
          "replaces_text": true
        }
      },
      {
        "value": "2",
        "text": "Figure 4"
      },
      {
        "value": "3",
        "text": "Figure 1"
      },
      {
        "value": "4",
        "text": "Figure 2"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Apply both independent attributes: the bottom-right entry is a filled square."
  },
  {
    "id": "bca19bd6-ce0b-531d-8e54-9488283b6f85",
    "display_order": 25,
    "question_text": "[General Intelligence and Reasoning] Count all triangles formed entirely by the drawn line segments in the diagram. Count triangles of every size.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "8",
        "question_image": {
          "url": "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MjAiIGhlaWdodD0iMjk3IiB2aWV3Qm94PSIwIDAgNTIwIDI5NyI+PHJlY3Qgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgZmlsbD0id2hpdGUiLz48dGV4dCB4PSIxMiIgeT0iMjAiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1IiBmaWxsPSIjMTcyNTU0Ij5Db3VudCBhbGwgdHJpYW5nbGVzIGZvcm1lZCBlbnRpcmVseSBieSB0aGUgZHJhd24gbGluZSBzZWdtZW50cyBpbiB0aGU8L3RleHQ+PHRleHQgeD0iMTIiIHk9IjQwIiBmb250LWZhbWlseT0iQXJpYWwsc2Fucy1zZXJpZiIgZm9udC1zaXplPSIxNSIgZmlsbD0iIzE3MjU1NCI+ZGlhZ3JhbS4gQ291bnQgdHJpYW5nbGVzIG9mIGV2ZXJ5IHNpemUuPC90ZXh0PjxnIHRyYW5zZm9ybT0idHJhbnNsYXRlKDAgNTIpIj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ3aGl0ZSIvPjxnIGZpbGw9Im5vbmUiIHN0cm9rZT0iIzE3MjU1NCIgc3Ryb2tlLXdpZHRoPSIzIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMjYwIDI1IEwxNDAgMjA1IEwzODAgMjA1IFogTTI2MCAyNSBWMjA1IE0yMDAgMTE1IEgzMjAiLz48dGV4dCB4PSIyNTUiIHk9IjE5IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5BPC90ZXh0Pjx0ZXh0IHg9IjEyMSIgeT0iMjIwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5CPC90ZXh0Pjx0ZXh0IHg9IjM4NSIgeT0iMjIwIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5DPC90ZXh0Pjx0ZXh0IHg9IjI1NSIgeT0iMjI1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5EPC90ZXh0Pjx0ZXh0IHg9IjE4MiIgeT0iMTE1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5FPC90ZXh0Pjx0ZXh0IHg9IjMyNSIgeT0iMTE1IiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5GPC90ZXh0Pjx0ZXh0IHg9IjI2OCIgeT0iMTEzIiBmaWxsPSIjMTcyNTU0IiBzdHJva2U9Im5vbmUiIGZvbnQtZmFtaWx5PSJBcmlhbCxzYW5zLXNlcmlmIiBmb250LXNpemU9IjE1Ij5HPC90ZXh0PjwvZz48L2c+PC9zdmc+",
          "alt": "Question 25: Count all triangles formed entirely by the drawn line segments in the diagram. Count triangles of every size.",
          "replaces_text": true
        }
      },
      {
        "value": "2",
        "text": "6"
      },
      {
        "value": "3",
        "text": "5"
      },
      {
        "value": "4",
        "text": "4"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "There are three triangles with apex A and base on EF (AEG,AGF,AEF), and three with base on BC (ABD,ADC,ABC). No other triple has all three sides drawn."
  },
  {
    "id": "584997ba-3597-54c5-9d5f-ad4fba022f7f",
    "display_order": 26,
    "question_text": "[General Awareness] Consider Dholavira: I. It lies on Khadir island in Gujarat. II. Its water-management system responded to an arid environment and seasonal streams. III. Its urban remains belong to the Harappan civilization. Which statements are correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "I and III only"
      },
      {
        "value": "2",
        "text": "II and III only"
      },
      {
        "value": "3",
        "text": "I, II and III"
      },
      {
        "value": "4",
        "text": "I and II only"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "UNESCO locates Dholavira on Khadir island and describes its Harappan settlement and water system fed by two seasonal streams."
  },
  {
    "id": "839627ac-3b3d-5e1e-be99-68300247de72",
    "display_order": 27,
    "question_text": "[General Awareness] Rani-ki-Vav at Patan is principally which type of monument?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "A free-standing victory tower"
      },
      {
        "value": "2",
        "text": "A rock-cut chaitya hall"
      },
      {
        "value": "3",
        "text": "A fortified hill palace"
      },
      {
        "value": "4",
        "text": "A subterranean stepwell"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "UNESCO describes Rani-ki-Vav as an elaborately constructed subterranean water-storage stepwell."
  },
  {
    "id": "afa6551e-6281-50f5-9150-39c84ac0931a",
    "display_order": 28,
    "question_text": "[General Awareness] Which sequence correctly orders the developments at Sanchi described by UNESCO, from earliest to latest?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Mauryan brick stupa; Gupta shrines; Sunga enlargement; Satavahana gateways"
      },
      {
        "value": "2",
        "text": "Sunga enlargement; Mauryan brick stupa; Gupta shrines; Satavahana gateways"
      },
      {
        "value": "3",
        "text": "Mauryan brick stupa; Sunga enlargement; Satavahana ornamentation of gateways; Gupta shrines"
      },
      {
        "value": "4",
        "text": "Satavahana gateways; Mauryan brick stupa; Sunga enlargement; Gupta shrines"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "UNESCO's synthesis attributes inception to Ashoka, enlargement to the Sungas, gateway ornamentation to the Satavahanas and cardinal shrines to the Guptas."
  },
  {
    "id": "d9206447-b324-560f-baa7-11de31e3c260",
    "display_order": 29,
    "question_text": "[General Awareness] Which pairing correctly distinguishes the two dates in UNESCO's account of Santiniketan?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Residential school in 1901; Visva Bharati in 1921"
      },
      {
        "value": "2",
        "text": "Residential school in 1881; Visva Bharati in 1901"
      },
      {
        "value": "3",
        "text": "Residential school in 1921; Visva Bharati in 1901"
      },
      {
        "value": "4",
        "text": "Residential school in 1901; Visva Bharati in 1941"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "UNESCO dates Tagore's residential school to 1901 and the world university Visva Bharati to 1921."
  },
  {
    "id": "e14df1fe-5626-56db-81b9-053e1adf44fa",
    "display_order": 30,
    "question_text": "[General Awareness] Match: P. Troposphere Q. Stratosphere R. Mesosphere. Descriptions: 1. Contains the ozone layer 2. Main weather-making layer 3. Lies above the stratosphere. Select the mapping.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "P-2, Q-1, R-3"
      },
      {
        "value": "2",
        "text": "P-3, Q-1, R-2"
      },
      {
        "value": "3",
        "text": "P-1, Q-2, R-3"
      },
      {
        "value": "4",
        "text": "P-2, Q-3, R-1"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "NCERT identifies the troposphere with weather, the stratosphere with ozone and the mesosphere above it."
  },
  {
    "id": "2f64e809-33f2-5ed1-9c1a-88558ab15704",
    "display_order": 31,
    "question_text": "[General Awareness] Two otherwise similar grass surfaces collect moisture overnight. The dew point is above freezing at site X and below freezing at site Y. Which deposition is consistent with the textbook distinction?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Liquid dew at both regardless of temperature"
      },
      {
        "value": "2",
        "text": "Liquid dew at X; ice crystals at Y"
      },
      {
        "value": "3",
        "text": "Ice crystals at both regardless of temperature"
      },
      {
        "value": "4",
        "text": "Ice crystals at X; liquid dew at Y"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Dew is liquid deposited on a cool surface above freezing; frost consists of ice crystals under freezing conditions. Temperature distinguishes the two outcomes."
  },
  {
    "id": "65526bde-7e91-5efc-843f-95b59a319014",
    "display_order": 32,
    "question_text": "[General Awareness] In the mature tropical cyclone model, which pairing is correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Eye: subsiding air; eyewall: strong ascent and greatest winds"
      },
      {
        "value": "2",
        "text": "Eye: greatest winds; eyewall: no condensation"
      },
      {
        "value": "3",
        "text": "Eye: uniformly rising air; eyewall: uniformly sinking air"
      },
      {
        "value": "4",
        "text": "Eye: strongest ascent; eyewall: calm descending air"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "NCERT distinguishes the relatively calm subsiding eye from the strongly ascending eyewall, where winds are greatest."
  },
  {
    "id": "5e19b05b-09a8-5606-95cc-0b1eba6ea765",
    "display_order": 33,
    "question_text": "[General Awareness] Under Article 72, consider: I. Court-martial sentences fall within presidential clemency power. II. The power includes all cases involving a death sentence. III. Article 72(2) removes every statutory power of armed-forces officers to commute court-martial sentences. Which are correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "II and III only"
      },
      {
        "value": "2",
        "text": "I and III only"
      },
      {
        "value": "3",
        "text": "I and II only"
      },
      {
        "value": "4",
        "text": "I, II and III"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Article 72(1) covers court martial and death sentences. Clause (2) preserves, rather than extinguishes, the relevant statutory powers of armed-forces officers."
  },
  {
    "id": "673c3f22-0759-58ea-a25d-402dfbc26423",
    "display_order": 34,
    "question_text": "[General Awareness] Article 9 expressly disqualifies a person who voluntarily acquired foreign citizenship from citizenship under which group of constitutional provisions?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Articles 5, 7 and 11"
      },
      {
        "value": "2",
        "text": "Articles 7, 8 and 10"
      },
      {
        "value": "3",
        "text": "Articles 5, 6 and 8"
      },
      {
        "value": "4",
        "text": "Articles 6, 10 and 11"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Article 9 specifically refers to citizenship by virtue of Article 5 and deemed citizenship under Articles 6 and 8."
  },
  {
    "id": "f7d1bfeb-c8cb-5a7d-98ca-9362f20a5c08",
    "display_order": 35,
    "question_text": "[General Awareness] An act carried a maximum criminal penalty of two years when committed. A later law raises the maximum to five years. Applying Article 20(1) to that earlier act, which statement is correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Any later amendment invalidates the original offence"
      },
      {
        "value": "2",
        "text": "The protection applies only if the accused was already convicted"
      },
      {
        "value": "3",
        "text": "The five-year maximum automatically replaces the earlier maximum"
      },
      {
        "value": "4",
        "text": "The later greater penalty cannot be imposed for the earlier act"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Article 20(1) prohibits a penalty greater than the one that could have been imposed under the law in force when the offence was committed."
  },
  {
    "id": "29a35610-5ab5-514d-be87-ce87dd4e6d69",
    "display_order": 36,
    "question_text": "[General Awareness] A consumer buys X on the horizontal axis and Y on the vertical axis. Income and Y's price remain fixed while X's price falls. Which combination follows for the budget line?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Horizontal intercept falls; vertical intercept unchanged; absolute slope rises"
      },
      {
        "value": "2",
        "text": "Horizontal intercept rises; vertical intercept unchanged; absolute slope falls"
      },
      {
        "value": "3",
        "text": "Both intercepts rise; absolute slope unchanged"
      },
      {
        "value": "4",
        "text": "Vertical intercept rises; horizontal intercept unchanged; absolute slope rises"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The intercepts are income/price(X) and income/price(Y), and absolute slope is price(X)/price(Y). Only X's falling price changes the first intercept and the slope."
  },
  {
    "id": "22093395-a44f-580d-b7e1-dd5e3d7e4e10",
    "display_order": 37,
    "question_text": "[General Awareness] Which statement correctly distinguishes an inferior good from a Giffen good in the standard consumer-demand model?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "An inferior good is one whose market price is lower than every substitute"
      },
      {
        "value": "2",
        "text": "A Giffen good is defined by demand rising when income rises"
      },
      {
        "value": "3",
        "text": "Every inferior good necessarily has an upward-sloping demand curve"
      },
      {
        "value": "4",
        "text": "Inferiority concerns the income response; Giffen behaviour requires a price response in which the income effect outweighs substitution"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Demand for an inferior good falls as income rises, other things equal. It becomes Giffen only when the opposing income effect dominates substitution in the price response."
  },
  {
    "id": "325ef18d-a849-5593-bc4c-1aa4a0d4720b",
    "display_order": 38,
    "question_text": "[General Awareness] Which transaction belongs to the current account rather than an asset transaction in the balance of payments?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Payment received for software services exported"
      },
      {
        "value": "2",
        "text": "Purchase of foreign company shares by a resident"
      },
      {
        "value": "3",
        "text": "A foreign investor's purchase of domestic equity"
      },
      {
        "value": "4",
        "text": "A resident bank's acquisition of a foreign bond"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Exported services are recorded in the current account; purchases of shares and bonds are transactions in financial assets."
  },
  {
    "id": "05a43670-d2c9-52c5-9965-ab2e54e744fd",
    "display_order": 39,
    "question_text": "[General Awareness] In electrolytic refining of copper, which arrangement is correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Pure copper anode, impure copper cathode, distilled water only"
      },
      {
        "value": "2",
        "text": "Graphite at both electrodes, dry copper sulphate crystals"
      },
      {
        "value": "3",
        "text": "Impure copper at both electrodes, molten sulphur electrolyte"
      },
      {
        "value": "4",
        "text": "Impure copper anode, pure copper cathode, copper-salt solution"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "NCERT describes the impure metal as anode, a thin pure-metal strip as cathode and a metal-salt solution as electrolyte."
  },
  {
    "id": "9b7de945-5047-5ea1-b9fa-deca833d1960",
    "display_order": 40,
    "question_text": "[General Awareness] Aluminium oxide reacts with both hydrochloric acid and sodium hydroxide. Which classification and products in these two reactions are consistent with NCERT?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Basic only; aluminium chloride in both reactions"
      },
      {
        "value": "2",
        "text": "Neutral; neither reaction forms a salt"
      },
      {
        "value": "3",
        "text": "Amphoteric; aluminium chloride and sodium aluminate respectively"
      },
      {
        "value": "4",
        "text": "Acidic only; sodium aluminate in both reactions"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Al2O3 reacts with acid to form aluminium chloride and with base to form sodium aluminate. Reactivity with both establishes amphoteric behaviour."
  },
  {
    "id": "691490b6-00ab-5c7d-a5ac-47b8b6f8af95",
    "display_order": 41,
    "question_text": "[General Awareness] A light ray enters glass from air along the normal. Which combination is correct?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Direction bends towards normal; speed decreases; frequency increases"
      },
      {
        "value": "2",
        "text": "Direction unchanged; speed decreases; frequency unchanged"
      },
      {
        "value": "3",
        "text": "Direction unchanged; speed unchanged; frequency decreases"
      },
      {
        "value": "4",
        "text": "Direction bends away from normal; speed increases; frequency unchanged"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "At normal incidence there is no angular deviation. In glass the speed falls; frequency is fixed by the source and remains unchanged across the interface."
  },
  {
    "id": "46f0781d-7ce7-5521-8bd7-311a4ba39a8d",
    "display_order": 42,
    "question_text": "[General Awareness] A patient can initiate voluntary movement but has difficulty maintaining balance and making precise movements. Which brain region is most directly associated with these functions?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Hypothalamus"
      },
      {
        "value": "2",
        "text": "Medulla"
      },
      {
        "value": "3",
        "text": "Olfactory lobe"
      },
      {
        "value": "4",
        "text": "Cerebellum"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "NCERT associates the cerebellum with precision of voluntary actions, posture and balance; the other regions have different primary roles."
  },
  {
    "id": "d545340f-c156-5179-a22e-c9672480cf6a",
    "display_order": 43,
    "question_text": "[General Awareness] Which sequence describes the insulin feedback example in NCERT?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Blood glucose falls; insulin rises continuously without feedback"
      },
      {
        "value": "2",
        "text": "Insulin is released only by the pituitary and not by the pancreas"
      },
      {
        "value": "3",
        "text": "Blood glucose rises; pancreatic insulin secretion rises; as glucose falls, insulin secretion falls"
      },
      {
        "value": "4",
        "text": "Blood glucose rises; insulin secretion falls; falling glucose then raises insulin"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Pancreatic cells respond to raised blood glucose with increased insulin; falling glucose reduces secretion, illustrating negative feedback."
  },
  {
    "id": "a6cbbd7b-3bc7-5093-979d-259260022798",
    "display_order": 44,
    "question_text": "[General Awareness] Match Chhau traditions to their regions: P. Seraikella Q. Purulia R. Mayurbhanj; 1. Odisha 2. Jharkhand 3. West Bengal. Select the correct mapping.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "P-3, Q-2, R-1"
      },
      {
        "value": "2",
        "text": "P-2, Q-3, R-1"
      },
      {
        "value": "3",
        "text": "P-1, Q-3, R-2"
      },
      {
        "value": "4",
        "text": "P-2, Q-1, R-3"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The three regional forms are Seraikella in Jharkhand, Purulia in West Bengal and Mayurbhanj in Odisha."
  },
  {
    "id": "530330b8-59f7-5216-ab12-63e0fc09f96f",
    "display_order": 45,
    "question_text": "[General Awareness] Which description correctly identifies Kutiyattam?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "A masked martial dance originating in Purulia"
      },
      {
        "value": "2",
        "text": "Sanskrit theatre associated with Kerala"
      },
      {
        "value": "3",
        "text": "A monastic masked dance specific to Ladakh"
      },
      {
        "value": "4",
        "text": "A narrative singing tradition specific to Rajasthan"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Kerala Tourism describes Kutiyattam as a Sanskrit theatrical tradition of Kerala, distinct from the other regional performance forms."
  },
  {
    "id": "de558d32-4b2d-513b-8b89-313ee935a6a0",
    "display_order": 46,
    "question_text": "[General Awareness] In traditional Kutiyattam accompaniment, the Mizhavu is principally what?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "A plucked lute"
      },
      {
        "value": "2",
        "text": "A bowed string instrument"
      },
      {
        "value": "3",
        "text": "A double-reed wind instrument"
      },
      {
        "value": "4",
        "text": "A copper percussion drum"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Kerala Tourism identifies the Mizhavu as the copper drum used as the primary percussion instrument in Kutiyattam."
  },
  {
    "id": "9401385a-8071-5e98-9ad0-5b03e629be97",
    "display_order": 47,
    "question_text": "[General Awareness] The 2025 Chemistry Nobel recognised Kitagawa, Robson and Yaghi for developing which class of materials?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Metal-organic frameworks"
      },
      {
        "value": "2",
        "text": "Semiconductor quantum dots"
      },
      {
        "value": "3",
        "text": "Lithium-ion cathodes"
      },
      {
        "value": "4",
        "text": "Conducting polymers"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The Royal Swedish Academy's 2025 announcement recognises metal-organic frameworks, a class of porous molecular architectures."
  },
  {
    "id": "5279076f-d10b-50d6-be9f-0787740299f4",
    "display_order": 48,
    "question_text": "[General Awareness] The 2025 Physics Nobel recognised experiments involving a macroscopic electrical circuit. Which phenomenon was central to that work?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Gravitational lensing by a distant galaxy"
      },
      {
        "value": "2",
        "text": "Electromagnetic induction in an ordinary generator"
      },
      {
        "value": "3",
        "text": "Quantum tunnelling and discrete energy levels"
      },
      {
        "value": "4",
        "text": "Nuclear fission and a neutron chain reaction"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The Royal Swedish Academy recognised experiments showing tunnelling and quantised energy in a large-scale superconducting electrical circuit; the other phenomena were not the subject of this prize."
  },
  {
    "id": "ebc920b8-b7af-5f34-8d8d-55fd9315bc52",
    "display_order": 49,
    "question_text": "[General Awareness] Which combination correctly describes the ICC Men's T20 World Cup 2026 final result reported by ICC?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "India defeated New Zealand by four wickets"
      },
      {
        "value": "2",
        "text": "India defeated New Zealand by 96 runs"
      },
      {
        "value": "3",
        "text": "India defeated Australia by 96 runs"
      },
      {
        "value": "4",
        "text": "New Zealand defeated India by six wickets"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "ICC reports India's 96-run victory over New Zealand in the 2026 final. The alternatives change the opponent, winner or margin type."
  },
  {
    "id": "e285996e-9eb8-5e92-b229-e3783721131b",
    "display_order": 50,
    "question_text": "[General Awareness] ISRO's update on the January 2026 PSLV-C62 mission reported an anomaly near the end of which stage?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "PS4, the fourth stage"
      },
      {
        "value": "2",
        "text": "PS1, the first stage"
      },
      {
        "value": "3",
        "text": "PS2, the second stage"
      },
      {
        "value": "4",
        "text": "PS3, the third stage"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "ISRO's mission page explicitly places the anomaly near the end of PS3. This question uses the mission update and does not imply a successful satellite deployment."
  },
  {
    "id": "14f0a64b-24a2-58f7-9db3-108e29d6c135",
    "display_order": 51,
    "question_text": "[Quantitative Aptitude] What is the remainder when 7^103 + 3^103 is divided by 10?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "2"
      },
      {
        "value": "2",
        "text": "0"
      },
      {
        "value": "3",
        "text": "6"
      },
      {
        "value": "4",
        "text": "8"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The last-digit cycles have period four. Since 103 leaves remainder three on division by four, the last digits are 3 and 7; their sum ends in zero."
  },
  {
    "id": "cee8cc6b-e95b-5deb-a9c0-243bd04e876f",
    "display_order": 52,
    "question_text": "[Quantitative Aptitude] What is the greatest four-digit integer that leaves remainder 7 when divided by each of 12, 15 and 18?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "9727"
      },
      {
        "value": "2",
        "text": "9997"
      },
      {
        "value": "3",
        "text": "9900"
      },
      {
        "value": "4",
        "text": "9907"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The LCM is 180. The number is 180k+7; the greatest such four-digit value is 180(55)+7=9907."
  },
  {
    "id": "0189440f-e334-5b98-a5cc-37e4357170ad",
    "display_order": 53,
    "question_text": "[Quantitative Aptitude] A commodity's price rises by 25% and the quantity bought falls by 12%. How does total expenditure change?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Increases by 10%"
      },
      {
        "value": "2",
        "text": "Increases by 13%"
      },
      {
        "value": "3",
        "text": "Decreases by 10%"
      },
      {
        "value": "4",
        "text": "Increases by 3%"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Expenditure multiplier=1.25 x 0.88=1.10, giving a 10% increase."
  },
  {
    "id": "645a006a-834e-520e-bc18-2545ed16bac6",
    "display_order": 54,
    "question_text": "[Quantitative Aptitude] A and B have incomes in the ratio 5:7 and expenditures in the ratio 3:4. Their savings are Rs 1200 and Rs 1800 respectively. What is B's income?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Rs 5400"
      },
      {
        "value": "2",
        "text": "Rs 4200"
      },
      {
        "value": "3",
        "text": "Rs 3600"
      },
      {
        "value": "4",
        "text": "Rs 4800"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Let incomes be 5x,7x and expenditure 3y,4y. From 5x-3y=1200 and 7x-4y=1800, x=600, so B earns 4200."
  },
  {
    "id": "c22ad7e0-05bd-59ec-8825-5b490f26510b",
    "display_order": 55,
    "question_text": "[Quantitative Aptitude] Nine scores have mean 50. Removing the greatest and least leaves seven scores with mean 48. The greatest exceeds the least by 30. Find the greatest score.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "78"
      },
      {
        "value": "2",
        "text": "84"
      },
      {
        "value": "3",
        "text": "66"
      },
      {
        "value": "4",
        "text": "72"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The two removed scores sum to 450-336=114. With difference 30, the greater is (114+30)/2=72."
  },
  {
    "id": "067f667b-358a-5d6f-9314-3d3a39385cf0",
    "display_order": 56,
    "question_text": "[Quantitative Aptitude] Equal masses of two copper-zinc alloys are mixed. Their copper:zinc ratios are 3:2 and 5:3. What is the copper:zinc ratio in the mixture?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "31:49"
      },
      {
        "value": "2",
        "text": "24:16"
      },
      {
        "value": "3",
        "text": "8:5"
      },
      {
        "value": "4",
        "text": "49:31"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "For one unit of each alloy, copper=3/5+5/8=49/40 and zinc=2/5+3/8=31/40. The ratio is 49:31."
  },
  {
    "id": "95d20c96-e43a-5834-961a-3ad32819a601",
    "display_order": 57,
    "question_text": "[Quantitative Aptitude] An article marked Rs 1500 is sold after successive discounts of 20% and 10%. The seller earns 8% profit on cost. Find the cost price.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Rs 1080"
      },
      {
        "value": "2",
        "text": "Rs 1125"
      },
      {
        "value": "3",
        "text": "Rs 960"
      },
      {
        "value": "4",
        "text": "Rs 1000"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Selling price=1500 x 0.8 x 0.9=1080. Cost=1080/1.08=1000."
  },
  {
    "id": "ff00a84b-836a-5c22-b3b0-6716158745d5",
    "display_order": 58,
    "question_text": "[Quantitative Aptitude] At simple interest, a sum amounts to Rs 13600 in three years and Rs 16000 in five years. Find the annual rate.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "10%"
      },
      {
        "value": "2",
        "text": "15%"
      },
      {
        "value": "3",
        "text": "12%"
      },
      {
        "value": "4",
        "text": "8%"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Two years' interest is 2400, so annual interest=1200. Principal=13600-3600=10000, giving 12%."
  },
  {
    "id": "9f0025ff-b7ca-59e0-818f-57119712748f",
    "display_order": 59,
    "question_text": "[Quantitative Aptitude] At 10% per annum, the difference between compound interest compounded annually and simple interest for two years is Rs 200. What is the compound amount after two years?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Rs 24200"
      },
      {
        "value": "2",
        "text": "Rs 24000"
      },
      {
        "value": "3",
        "text": "Rs 22000"
      },
      {
        "value": "4",
        "text": "Rs 24400"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The two-year interest difference is P(0.1)^2=200, hence P=20000. Compound amount=20000(1.1)^2=24200."
  },
  {
    "id": "a34fbd0d-4300-5220-9df8-81b7f1a40c59",
    "display_order": 60,
    "question_text": "[Quantitative Aptitude] A, B and C alone finish a job in 12, 18 and 36 days respectively. A and B work for three days, then C joins them. All continue until completion. Find the total duration.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "5.5 days"
      },
      {
        "value": "2",
        "text": "6 days"
      },
      {
        "value": "3",
        "text": "6.5 days"
      },
      {
        "value": "4",
        "text": "7.5 days"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "A+B complete 3(1/12+1/18)=5/12. All three work at 1/6 per day, so the remaining 7/12 takes 3.5 days; total=6.5."
  },
  {
    "id": "9bd48620-5c00-5471-80ca-3e6f231882ce",
    "display_order": 61,
    "question_text": "[Quantitative Aptitude] An inlet fills a tank in 12 hours; a leak empties a full tank in 20 hours. Both operate for four hours from empty, then the leak is closed. How much additional time does the inlet need?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "10 hours 24 minutes"
      },
      {
        "value": "2",
        "text": "8 hours 48 minutes"
      },
      {
        "value": "3",
        "text": "9 hours 36 minutes"
      },
      {
        "value": "4",
        "text": "14 hours 24 minutes"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Net filling in four hours is 4(1/12-1/20)=2/15. Remaining 13/15 takes (13/15)12=10.4 hours, or 10 hours 24 minutes. The total elapsed time would be 14 hours 24 minutes."
  },
  {
    "id": "0c0e0125-54f6-5fe2-9b5f-d5b5ef1039fd",
    "display_order": 62,
    "question_text": "[Quantitative Aptitude] Two trains have lengths in the ratio 3:2 and travel at 72 km/h and 54 km/h in opposite directions. They completely cross in eight seconds. How long does the first train take to cross a 252 m bridge?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "24 seconds"
      },
      {
        "value": "2",
        "text": "18 seconds"
      },
      {
        "value": "3",
        "text": "28 seconds"
      },
      {
        "value": "4",
        "text": "21 seconds"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Relative speed=35 m/s, so combined length=280 m. First train length=168 m. At 20 m/s, crossing 168+252=420 m takes 21 s."
  },
  {
    "id": "c852fe6a-9753-5bba-a0d9-508febc4395d",
    "display_order": 63,
    "question_text": "[Quantitative Aptitude] A tank holds 40 litres of milk and 10 litres of water. A quantity x litres of the mixture is removed and replaced by water, and the same operation is repeated with x litres. Finally 25.6 litres of milk remain. Find x.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "15 litres"
      },
      {
        "value": "2",
        "text": "10 litres"
      },
      {
        "value": "3",
        "text": "8 litres"
      },
      {
        "value": "4",
        "text": "12 litres"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Milk remaining=40(1-x/50)^2=25.6. Since 0<=x<=50, 1-x/50=0.8, so x=10."
  },
  {
    "id": "f633556a-4333-52e2-9098-ebd81e7d4d81",
    "display_order": 64,
    "question_text": "[Quantitative Aptitude] If x is positive and x+1/x=3, find x^3+1/x^3.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "24"
      },
      {
        "value": "2",
        "text": "18"
      },
      {
        "value": "3",
        "text": "27"
      },
      {
        "value": "4",
        "text": "21"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Cubing gives 27=x^3+1/x^3+3(x+1/x), so the required value is 27-9=18."
  },
  {
    "id": "64677bfd-5fb8-50ed-8f64-124e5754c506",
    "display_order": 65,
    "question_text": "[Quantitative Aptitude] If a and b are the roots of t^2-7t+10=0, find a^2/b+b^2/a.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "49/10"
      },
      {
        "value": "2",
        "text": "133/10"
      },
      {
        "value": "3",
        "text": "119/10"
      },
      {
        "value": "4",
        "text": "143/10"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "a+b=7 and ab=10. The expression=(a^3+b^3)/ab=[(a+b)^3-3ab(a+b)]/ab=(343-210)/10=133/10."
  },
  {
    "id": "2a63121f-0491-53fa-955c-8dc4f4f46322",
    "display_order": 66,
    "question_text": "[Quantitative Aptitude] A triangle has side lengths 13 cm, 14 cm and 15 cm. Find its inradius.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "4 cm"
      },
      {
        "value": "2",
        "text": "5 cm"
      },
      {
        "value": "3",
        "text": "6 cm"
      },
      {
        "value": "4",
        "text": "3 cm"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Semiperimeter=21. Heron's formula gives area=sqrt(21 x 8 x 7 x 6)=84. Inradius=84/21=4."
  },
  {
    "id": "faeb7240-50af-5d96-a3ed-e1d421bbfd78",
    "display_order": 67,
    "question_text": "[Quantitative Aptitude] From point P, a tangent PA to a circle is 12 cm long. The distance from P to centre O is 13 cm. Find the radius.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "10 cm"
      },
      {
        "value": "2",
        "text": "6 cm"
      },
      {
        "value": "3",
        "text": "7 cm"
      },
      {
        "value": "4",
        "text": "5 cm"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "OA is perpendicular to PA, so radius=sqrt(13^2-12^2)=5 cm."
  },
  {
    "id": "583745b3-9842-55ed-8d2f-a2b4e531e5e3",
    "display_order": 68,
    "question_text": "[Quantitative Aptitude] In a circle, a chord of length 16 cm lies 6 cm from the centre. A second chord lies 8 cm from the centre. Find the second chord's length.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "14 cm"
      },
      {
        "value": "2",
        "text": "10 cm"
      },
      {
        "value": "3",
        "text": "12 cm"
      },
      {
        "value": "4",
        "text": "8 cm"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "First half-chord=8, so radius=sqrt(8^2+6^2)=10. Second half-chord=sqrt(10^2-8^2)=6, giving length 12."
  },
  {
    "id": "23b795f3-b5e8-5e0c-9d48-b87ce37c533c",
    "display_order": 69,
    "question_text": "[Quantitative Aptitude] A solid cone of radius 6 cm and height 8 cm is melted into solid spheres of radius 2 cm, without loss. How many spheres are formed?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "6"
      },
      {
        "value": "2",
        "text": "9"
      },
      {
        "value": "3",
        "text": "12"
      },
      {
        "value": "4",
        "text": "18"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Cone volume=(1/3)pi(36)(8)=96pi. Each sphere has volume=(4/3)pi(8)=32pi/3. The quotient is 9."
  },
  {
    "id": "04349239-9ee7-589f-a20e-f01e05b81c51",
    "display_order": 70,
    "question_text": "[Quantitative Aptitude] An open-top cylindrical vessel has radius 7 cm and height 10 cm. Only its outside curved surface and outside base are painted, at Rs 2 per square cm. Ignoring thickness and using pi=22/7, find the cost.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Rs 1188"
      },
      {
        "value": "2",
        "text": "Rs 880"
      },
      {
        "value": "3",
        "text": "Rs 1496"
      },
      {
        "value": "4",
        "text": "Rs 594"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Area=2pi rh+pi r^2=440+154=594 square cm. At Rs 2 per square cm the cost is 1188."
  },
  {
    "id": "63b3477e-11e0-5aeb-a3e7-d75c46c24d23",
    "display_order": 71,
    "question_text": "[Quantitative Aptitude] For acute theta, tan(theta)+cot(theta)=4. Find sin^4(theta)+cos^4(theta).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "1/2"
      },
      {
        "value": "2",
        "text": "7/8"
      },
      {
        "value": "3",
        "text": "3/4"
      },
      {
        "value": "4",
        "text": "15/16"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "tan+cot=1/(sin cos), so sin^2 cos^2=1/16. Therefore sin^4+cos^4=1-2/16=7/8."
  },
  {
    "id": "b925cb74-8a38-54c1-a0ba-a5fc88c7099f",
    "display_order": 72,
    "question_text": "[Quantitative Aptitude] From two points on level ground on the same side of a tower, the angles of elevation of its top are 30 and 60 degrees. The points are 40 m apart. Find the tower's height.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "60 m"
      },
      {
        "value": "2",
        "text": "20 m"
      },
      {
        "value": "3",
        "text": "40sqrt(3) m"
      },
      {
        "value": "4",
        "text": "20sqrt(3) m"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "If the nearer distance is d, h=d sqrt(3)=(d+40)/sqrt(3). Thus 3d=d+40, d=20, h=20sqrt(3)."
  },
  {
    "id": "33b0d8f9-92d3-5c50-86ec-ed73b7bb873c",
    "display_order": 73,
    "question_text": "[Quantitative Aptitude] Output in units.\nUnit | Planned | Actual\nA | 120 | 108\nB | 150 | 180\nC | 180 | 144\nD | 100 | 110\nE | 200 | 168\n\nUsing table DI-1, find total actual output as a percentage of total planned output, rounded to two decimal places.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "95.00%"
      },
      {
        "value": "2",
        "text": "93.33%"
      },
      {
        "value": "3",
        "text": "96.00%"
      },
      {
        "value": "4",
        "text": "94.67%"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Total actual=710 and total planned=750. Percentage=710/750 x 100=94.666..., rounding to 94.67%; do not average unweighted percentages."
  },
  {
    "id": "dc0aace4-afa9-5b47-b87a-b980dcc9e346",
    "display_order": 74,
    "question_text": "[Quantitative Aptitude] Output in units.\nUnit | Planned | Actual\nA | 120 | 108\nB | 150 | 180\nC | 180 | 144\nD | 100 | 110\nE | 200 | 168\n\nUsing table DI-1, which unit has the greatest absolute shortfall of actual output below plan?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Unit D"
      },
      {
        "value": "2",
        "text": "Unit A"
      },
      {
        "value": "3",
        "text": "Unit C"
      },
      {
        "value": "4",
        "text": "Unit E"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Shortfalls are A=12, C=36 and E=32; B and D exceed plan. C has the greatest shortfall."
  },
  {
    "id": "74c32675-9a10-5246-b4ca-473db2957731",
    "display_order": 75,
    "question_text": "[Quantitative Aptitude] Output in units.\nUnit | Planned | Actual\nA | 120 | 108\nB | 150 | 180\nC | 180 | 144\nD | 100 | 110\nE | 200 | 168\n\nUsing table DI-1, 10% of B's actual output is reassigned to C without changing total output. By what percentage does C's actual output increase?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "20%"
      },
      {
        "value": "2",
        "text": "15%"
      },
      {
        "value": "3",
        "text": "12.5%"
      },
      {
        "value": "4",
        "text": "10%"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Transferred output=10% of 180=18. Relative increase for C=18/144 x 100=12.5%."
  },
  {
    "id": "047c265f-3693-5de4-9b84-f409a29d1ccf",
    "display_order": 76,
    "question_text": "[English Comprehension] When a coastal town replaced its ageing public clocks, officials expected the new synchronised displays to end complaints about late buses. The clocks became accurate, but the complaints continued. A subsequent survey showed that passengers cared less about the exact minute than about whether a promised service arrived at all. The transport office had been measuring departures from the depot, while residents were describing arrivals at stops. Neither account was fabricated; the two groups were answering different questions.\n\nInstead of buying another display system, the town published a simple stop-by-stop service log. Drivers could annotate delays, and passengers could report missing journeys. The first month produced more complaints, which opponents called evidence of failure. Yet many of these complaints concerned disruptions that had previously gone unrecorded. Over the following months, the shared record helped staff identify a recurring scheduling conflict. The lesson was not that technology was useless. It was that a precise measurement could still miss the experience it was meant to represent, and that making a problem visible might temporarily make the statistics look worse.\n\nRead passage RC-1. Which statement best captures its central argument?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Public complaints necessarily prove that a reform has failed"
      },
      {
        "value": "2",
        "text": "More precise clocks inevitably improve every public service"
      },
      {
        "value": "3",
        "text": "Personal experience makes all quantitative records unnecessary"
      },
      {
        "value": "4",
        "text": "An accurate metric can be inadequate when it measures a different outcome from the one users need"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The depot-departure measure was accurate but did not represent arrivals at stops. The closing sentences distinguish precision from relevance rather than rejecting measurement."
  },
  {
    "id": "83b0d91c-0571-53bd-97e5-d3a1433d9663",
    "display_order": 77,
    "question_text": "[English Comprehension] When a coastal town replaced its ageing public clocks, officials expected the new synchronised displays to end complaints about late buses. The clocks became accurate, but the complaints continued. A subsequent survey showed that passengers cared less about the exact minute than about whether a promised service arrived at all. The transport office had been measuring departures from the depot, while residents were describing arrivals at stops. Neither account was fabricated; the two groups were answering different questions.\n\nInstead of buying another display system, the town published a simple stop-by-stop service log. Drivers could annotate delays, and passengers could report missing journeys. The first month produced more complaints, which opponents called evidence of failure. Yet many of these complaints concerned disruptions that had previously gone unrecorded. Over the following months, the shared record helped staff identify a recurring scheduling conflict. The lesson was not that technology was useless. It was that a precise measurement could still miss the experience it was meant to represent, and that making a problem visible might temporarily make the statistics look worse.\n\nRead passage RC-1. Which inference is best supported by the different accounts of drivers and passengers?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Two truthful accounts can conflict in appearance because they refer to different stages of a service"
      },
      {
        "value": "2",
        "text": "Passengers were unable to read the synchronised clocks"
      },
      {
        "value": "3",
        "text": "At least one group must have deliberately falsified its observations"
      },
      {
        "value": "4",
        "text": "Depot departures and stop arrivals are interchangeable measures"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Both groups are expressly described as truthful, but one measured depot departures and the other stop arrivals. The inference is about different frames of reference, not dishonesty."
  },
  {
    "id": "d6efbf40-1506-57e7-9699-01eed1fe6b8a",
    "display_order": 78,
    "question_text": "[English Comprehension] When a coastal town replaced its ageing public clocks, officials expected the new synchronised displays to end complaints about late buses. The clocks became accurate, but the complaints continued. A subsequent survey showed that passengers cared less about the exact minute than about whether a promised service arrived at all. The transport office had been measuring departures from the depot, while residents were describing arrivals at stops. Neither account was fabricated; the two groups were answering different questions.\n\nInstead of buying another display system, the town published a simple stop-by-stop service log. Drivers could annotate delays, and passengers could report missing journeys. The first month produced more complaints, which opponents called evidence of failure. Yet many of these complaints concerned disruptions that had previously gone unrecorded. Over the following months, the shared record helped staff identify a recurring scheduling conflict. The lesson was not that technology was useless. It was that a precise measurement could still miss the experience it was meant to represent, and that making a problem visible might temporarily make the statistics look worse.\n\nRead passage RC-1. Why is the initial increase in complaints not sufficient evidence that the logging reform worsened service?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "The town stopped running buses during the survey"
      },
      {
        "value": "2",
        "text": "Opponents had changed the clocks to show the wrong time"
      },
      {
        "value": "3",
        "text": "The new process recorded disruptions that had formerly been invisible"
      },
      {
        "value": "4",
        "text": "Every initial complaint was later withdrawn"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "More reports can reflect improved detection rather than more underlying disruptions. The passage does not claim that all complaints were withdrawn or that service stopped."
  },
  {
    "id": "4a2ff632-3c09-5e49-ba72-07030d8ac374",
    "display_order": 79,
    "question_text": "[English Comprehension] When a coastal town replaced its ageing public clocks, officials expected the new synchronised displays to end complaints about late buses. The clocks became accurate, but the complaints continued. A subsequent survey showed that passengers cared less about the exact minute than about whether a promised service arrived at all. The transport office had been measuring departures from the depot, while residents were describing arrivals at stops. Neither account was fabricated; the two groups were answering different questions.\n\nInstead of buying another display system, the town published a simple stop-by-stop service log. Drivers could annotate delays, and passengers could report missing journeys. The first month produced more complaints, which opponents called evidence of failure. Yet many of these complaints concerned disruptions that had previously gone unrecorded. Over the following months, the shared record helped staff identify a recurring scheduling conflict. The lesson was not that technology was useless. It was that a precise measurement could still miss the experience it was meant to represent, and that making a problem visible might temporarily make the statistics look worse.\n\nRead passage RC-1. Which description best fits the author's attitude towards technology?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Qualified support, provided that measurement serves the relevant purpose"
      },
      {
        "value": "2",
        "text": "Unconditional enthusiasm for every new display"
      },
      {
        "value": "3",
        "text": "Nostalgia for inaccurate clocks"
      },
      {
        "value": "4",
        "text": "Complete rejection of technology in transport"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The author explicitly says the lesson was not that technology was useless, but that its measurement must represent the experience of interest."
  },
  {
    "id": "a04d9bb3-31ca-5232-883b-77d1605a7ca1",
    "display_order": 80,
    "question_text": "[English Comprehension] When a coastal town replaced its ageing public clocks, officials expected the new synchronised displays to end complaints about late buses. The clocks became accurate, but the complaints continued. A subsequent survey showed that passengers cared less about the exact minute than about whether a promised service arrived at all. The transport office had been measuring departures from the depot, while residents were describing arrivals at stops. Neither account was fabricated; the two groups were answering different questions.\n\nInstead of buying another display system, the town published a simple stop-by-stop service log. Drivers could annotate delays, and passengers could report missing journeys. The first month produced more complaints, which opponents called evidence of failure. Yet many of these complaints concerned disruptions that had previously gone unrecorded. Over the following months, the shared record helped staff identify a recurring scheduling conflict. The lesson was not that technology was useless. It was that a precise measurement could still miss the experience it was meant to represent, and that making a problem visible might temporarily make the statistics look worse.\n\nRead passage RC-1. Which additional finding would most weaken the claim that the early increase in complaints mainly reflected better recording?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "The log allowed passengers to report missing journeys"
      },
      {
        "value": "2",
        "text": "An unchanged independent monitoring system also detected a sharp increase in actual service disruptions during the same month"
      },
      {
        "value": "3",
        "text": "Some complaints described previously unrecorded disruptions"
      },
      {
        "value": "4",
        "text": "Drivers could attach explanations to logged delays"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "An unchanged independent measure showing real deterioration provides an alternative explanation for the increased complaints. The other options are consistent with better recording."
  },
  {
    "id": "9831690c-d53a-5a98-a2b4-d3bec0a2e310",
    "display_order": 81,
    "question_text": "[English Comprehension] An archive is useful not merely because it preserves documents, but because it makes their origins (1) ___. A note without a date may still be valuable, (2) ___ its claims must be read cautiously. Archivists therefore record the context in which an item was produced, rather than treating every surviving sheet as (3) ___ reliable. Such work does not eliminate uncertainty; it gives readers the means to (4) ___ it. The aim is not to replace judgement (5) ___ a catalogue, but to make judgement better informed.\n\nIn cloze passage CL-1, choose the best word for blank (1).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "disposable"
      },
      {
        "value": "2",
        "text": "inevitable"
      },
      {
        "value": "3",
        "text": "ornamental"
      },
      {
        "value": "4",
        "text": "traceable"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Making origins traceable allows readers to identify provenance. Disposable, inevitable and ornamental do not express that function."
  },
  {
    "id": "4618e9d2-564b-5ab9-a586-ae6319bec3af",
    "display_order": 82,
    "question_text": "[English Comprehension] An archive is useful not merely because it preserves documents, but because it makes their origins (1) ___. A note without a date may still be valuable, (2) ___ its claims must be read cautiously. Archivists therefore record the context in which an item was produced, rather than treating every surviving sheet as (3) ___ reliable. Such work does not eliminate uncertainty; it gives readers the means to (4) ___ it. The aim is not to replace judgement (5) ___ a catalogue, but to make judgement better informed.\n\nIn cloze passage CL-1, choose the best connector for blank (2).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "but"
      },
      {
        "value": "2",
        "text": "because"
      },
      {
        "value": "3",
        "text": "unless"
      },
      {
        "value": "4",
        "text": "so"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The note may retain value, but the missing date requires caution. The clause introduces a qualification, not a cause, condition or consequence."
  },
  {
    "id": "7e702de2-5096-56e3-a1e1-541285a2a771",
    "display_order": 83,
    "question_text": "[English Comprehension] An archive is useful not merely because it preserves documents, but because it makes their origins (1) ___. A note without a date may still be valuable, (2) ___ its claims must be read cautiously. Archivists therefore record the context in which an item was produced, rather than treating every surviving sheet as (3) ___ reliable. Such work does not eliminate uncertainty; it gives readers the means to (4) ___ it. The aim is not to replace judgement (5) ___ a catalogue, but to make judgement better informed.\n\nIn cloze passage CL-1, choose the best word for blank (3).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "barely"
      },
      {
        "value": "2",
        "text": "accidentally"
      },
      {
        "value": "3",
        "text": "remotely"
      },
      {
        "value": "4",
        "text": "equally"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The contrast is between assessing individual provenance and treating all surviving sheets as equally reliable. The other adverbs do not express an indiscriminate uniform judgement."
  },
  {
    "id": "a3994221-435c-5e83-94a6-3d387a217454",
    "display_order": 84,
    "question_text": "[English Comprehension] An archive is useful not merely because it preserves documents, but because it makes their origins (1) ___. A note without a date may still be valuable, (2) ___ its claims must be read cautiously. Archivists therefore record the context in which an item was produced, rather than treating every surviving sheet as (3) ___ reliable. Such work does not eliminate uncertainty; it gives readers the means to (4) ___ it. The aim is not to replace judgement (5) ___ a catalogue, but to make judgement better informed.\n\nIn cloze passage CL-1, choose the best verb for blank (4).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "abolish"
      },
      {
        "value": "2",
        "text": "conceal"
      },
      {
        "value": "3",
        "text": "multiply"
      },
      {
        "value": "4",
        "text": "assess"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The previous clause says uncertainty is not eliminated. Readers are instead enabled to assess it; abolish contradicts that qualification."
  },
  {
    "id": "a149815f-5169-591d-88f0-5a881fea49c4",
    "display_order": 85,
    "question_text": "[English Comprehension] An archive is useful not merely because it preserves documents, but because it makes their origins (1) ___. A note without a date may still be valuable, (2) ___ its claims must be read cautiously. Archivists therefore record the context in which an item was produced, rather than treating every surviving sheet as (3) ___ reliable. Such work does not eliminate uncertainty; it gives readers the means to (4) ___ it. The aim is not to replace judgement (5) ___ a catalogue, but to make judgement better informed.\n\nIn cloze passage CL-1, choose the correct preposition for blank (5).",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "to"
      },
      {
        "value": "2",
        "text": "against"
      },
      {
        "value": "3",
        "text": "with"
      },
      {
        "value": "4",
        "text": "from"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The construction is 'replace X with Y': replace judgement with a catalogue. None of to, from or against completes that construction here."
  },
  {
    "id": "9d54915f-ed2c-55d4-bfe4-3a06118c651d",
    "display_order": 86,
    "question_text": "[English Comprehension] Choose the grammatically correct completion: 'The quality of the reports, rather than their number, ___ the committee's decision.'",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "were determining"
      },
      {
        "value": "2",
        "text": "determines"
      },
      {
        "value": "3",
        "text": "have determined"
      },
      {
        "value": "4",
        "text": "determine"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The head of the subject is singular 'quality'; the intervening phrase does not make it plural. 'Determines' agrees with it."
  },
  {
    "id": "c6158e70-1c07-511b-be18-1f56fda1eece",
    "display_order": 87,
    "question_text": "[English Comprehension] Choose the correct completion: 'Not until the audit was complete ___ the missing entries.'",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "had the team discover"
      },
      {
        "value": "2",
        "text": "the team has discover"
      },
      {
        "value": "3",
        "text": "did the team discover"
      },
      {
        "value": "4",
        "text": "the team did discovered"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Fronted 'not until' requires subject-auxiliary inversion in the main clause. 'Did' takes the base form 'discover'."
  },
  {
    "id": "0458ae53-9494-52d7-957b-8d8a67ba1eff",
    "display_order": 88,
    "question_text": "[English Comprehension] Select the grammatically correct sentence.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Having inspected the bridge, the report recorded several cracks"
      },
      {
        "value": "2",
        "text": "Having inspected the bridge, there were several cracks in the report"
      },
      {
        "value": "3",
        "text": "Having inspected the bridge, the engineers recorded several cracks in the report"
      },
      {
        "value": "4",
        "text": "Having inspected the bridge, several cracks had appeared in the report"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The subject following the introductory participial clause must be the inspecting agent. Only 'the engineers' can perform the inspection."
  },
  {
    "id": "7d9fae53-ed81-58bf-8537-382d7fa60a0f",
    "display_order": 89,
    "question_text": "[English Comprehension] Select the grammatically correct sentence.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Implementing the revised plan costs less than the original plan itself"
      },
      {
        "value": "2",
        "text": "The revised plan is more economical to implement than the original plan was"
      },
      {
        "value": "3",
        "text": "The revised plan's implementation cost is lower than implementing the original plan"
      },
      {
        "value": "4",
        "text": "The cost of implementing the revised plan is lower than the original plan"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The correct option compares plans in the same respect, with 'was' supplying the parallel predicate. The alternatives compare a cost or activity with an unlike object."
  },
  {
    "id": "3114503e-4756-5ace-9a36-5c650af1d7bb",
    "display_order": 90,
    "question_text": "[English Comprehension] Which word best completes: 'Her approval was not wholehearted; it was a ___ endorsement, subject to two conditions.'",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "unreserved"
      },
      {
        "value": "2",
        "text": "categorical"
      },
      {
        "value": "3",
        "text": "qualified"
      },
      {
        "value": "4",
        "text": "unequivocal"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "A qualified endorsement is limited by reservations or conditions. The other adjectives imply an unambiguous or unreserved endorsement."
  },
  {
    "id": "c89369e2-2f01-5a50-9464-1fb8480456c7",
    "display_order": 91,
    "question_text": "[English Comprehension] In 'The witness gave a lucid account', choose the closest antonym of 'lucid'.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "incoherent"
      },
      {
        "value": "2",
        "text": "concise"
      },
      {
        "value": "3",
        "text": "candid"
      },
      {
        "value": "4",
        "text": "explicit"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Lucid means clear and intelligible; incoherent is its closest opposite here. Candid, concise and explicit concern honesty, brevity and clarity respectively."
  },
  {
    "id": "e7813faa-c4b3-5e91-81dc-de00ac57d28f",
    "display_order": 92,
    "question_text": "[English Comprehension] In 'The committee refused to move the goalposts after applications had closed', what does 'move the goalposts' mean?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Extend equal support to all applicants"
      },
      {
        "value": "2",
        "text": "Withdraw an inaccurate factual claim"
      },
      {
        "value": "3",
        "text": "Change the criteria after the process has begun"
      },
      {
        "value": "4",
        "text": "Publish the existing criteria more clearly"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Moving the goalposts means changing the rules or success criteria during a process, making an existing target unstable."
  },
  {
    "id": "3d56b41f-9e2e-5a1e-b14b-7ec51427be9c",
    "display_order": 93,
    "question_text": "[English Comprehension] Choose the word for a person who studies the origins and historical development of words.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Epigraphist"
      },
      {
        "value": "2",
        "text": "Etymologist"
      },
      {
        "value": "3",
        "text": "Entomologist"
      },
      {
        "value": "4",
        "text": "Ethnologist"
      }
    ],
    "correct_answer": "2",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "An etymologist studies word origins; an entomologist studies insects, an ethnologist peoples and cultures, and an epigraphist inscriptions."
  },
  {
    "id": "abfc1b51-b0ea-55e3-bdae-af8e2842c6c6",
    "display_order": 94,
    "question_text": "[English Comprehension] In 'The amendment must not curtail the committee's existing powers', what does 'curtail' mean?",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Reduce or restrict"
      },
      {
        "value": "2",
        "text": "Explain in detail"
      },
      {
        "value": "3",
        "text": "Confer or grant"
      },
      {
        "value": "4",
        "text": "Transfer by delegation"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Curtail means reduce or restrict. Conferring grants powers, delegating transfers authority, and detailing explains it; none means curtailing."
  },
  {
    "id": "cd74f08b-913b-539d-9b3d-97003c549f16",
    "display_order": 95,
    "question_text": "[English Comprehension] Choose the correctly spelt word.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Consciencious"
      },
      {
        "value": "2",
        "text": "Conscientous"
      },
      {
        "value": "3",
        "text": "Conscientious"
      },
      {
        "value": "4",
        "text": "Conscentious"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The standard spelling is conscientious, retaining the sequence 'scient' and ending in 'ious'."
  },
  {
    "id": "4c5ad039-d521-5ac7-940e-fd1612c82ad2",
    "display_order": 96,
    "question_text": "[English Comprehension] Choose the correctly spelt word.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Acquiescence"
      },
      {
        "value": "2",
        "text": "Acuiescence"
      },
      {
        "value": "3",
        "text": "Acquiescense"
      },
      {
        "value": "4",
        "text": "Acquiessence"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The standard form is acquiescence: ac-quies-cence. The other forms alter or omit required letters."
  },
  {
    "id": "03bddde6-82a3-52a3-a8af-743e172836db",
    "display_order": 97,
    "question_text": "[English Comprehension] Choose the correct passive equivalent of 'People believe that the manuscript was written in the fifteenth century.'",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "The manuscript is believed to have been written in the fifteenth century"
      },
      {
        "value": "2",
        "text": "The manuscript believes to have written in the fifteenth century"
      },
      {
        "value": "3",
        "text": "The manuscript was believed to write in the fifteenth century"
      },
      {
        "value": "4",
        "text": "The manuscript is believed to be writing in the fifteenth century"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The reporting verb remains present passive ('is believed'); the earlier passive event is expressed by the perfect passive infinitive 'to have been written'."
  },
  {
    "id": "96f9d010-8fef-514c-b7ba-d08582888353",
    "display_order": 98,
    "question_text": "[English Comprehension] On Friday, Leela said, 'I will submit the revised draft tomorrow.' Choose the correct reported form of her statement when reporting it on Sunday.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "Leela said that she would submit the revised draft the following day"
      },
      {
        "value": "2",
        "text": "Leela said that she would have submitted the revised draft yesterday"
      },
      {
        "value": "3",
        "text": "Leela said that she had submitted the revised draft the previous day"
      },
      {
        "value": "4",
        "text": "Leela said that she will submit the revised draft tomorrow"
      }
    ],
    "correct_answer": "1",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "In ordinary reported speech, will becomes would and tomorrow becomes the following day. The original promise concerned Saturday; do not turn a promise into a completed action."
  },
  {
    "id": "f372378e-6f27-5a7a-8e5f-2b6190bc9f94",
    "display_order": 99,
    "question_text": "[English Comprehension] Arrange: P. This exposed a gap in the original estimate. Q. The survey first counted only registered shops. R. Researchers then included unregistered street stalls. S. The revised total was consequently much higher. Choose the coherent sequence.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "S-Q-P-R"
      },
      {
        "value": "2",
        "text": "R-P-Q-S"
      },
      {
        "value": "3",
        "text": "Q-R-S-P"
      },
      {
        "value": "4",
        "text": "P-Q-S-R"
      }
    ],
    "correct_answer": "3",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "Q introduces the initial count, R broadens it, S gives the consequence, and P interprets the discrepancy. 'This' refers back to the higher revised total."
  },
  {
    "id": "5c4d9be8-3f79-5cd0-a0d9-9c9957c58398",
    "display_order": 100,
    "question_text": "[English Comprehension] Arrange: P. Yet the surface remained dry. Q. The forecast had predicted heavy rain. R. The caretaker therefore postponed watering the beds. S. By evening, he realised the forecast had not been borne out. Choose the coherent sequence.",
    "question_type": "mcq",
    "options": [
      {
        "value": "1",
        "text": "P-S-Q-R"
      },
      {
        "value": "2",
        "text": "Q-P-S-R"
      },
      {
        "value": "3",
        "text": "R-Q-S-P"
      },
      {
        "value": "4",
        "text": "Q-R-P-S"
      }
    ],
    "correct_answer": "4",
    "marks": 2,
    "negative_marks": 0.5,
    "explanation": "The forecast motivates postponing watering; 'yet' contrasts the expected rain with the dry surface, and the evening realisation concludes the sequence."
  }
]$questions$::JSONB;
 v_actual JSONB;
 v_subject UUID;
 v_count INT;
 v_existing public.mock_tests%ROWTYPE;
BEGIN
 PERFORM pg_advisory_xact_lock(hashtext(v_title)::BIGINT);
 IF jsonb_array_length(v_payload)<>100 OR
    (SELECT count(DISTINCT (x->>'display_order')::INT) FROM jsonb_array_elements(v_payload) x)<>100 OR
    (SELECT min((x->>'display_order')::INT) FROM jsonb_array_elements(v_payload) x)<>1 OR
    (SELECT max((x->>'display_order')::INT) FROM jsonb_array_elements(v_payload) x)<>100 OR
    EXISTS (SELECT 1 FROM jsonb_array_elements(v_payload) x WHERE
      (x->>'marks')::NUMERIC<>2 OR (x->>'negative_marks')::NUMERIC<>0.5 OR
      jsonb_array_length(x->'options')<>4 OR x->>'correct_answer' NOT IN ('1','2','3','4')) THEN
  RAISE EXCEPTION 'Invalid SSC payload: expected orders 1-100, four options and +2/-0.5 marking';
 END IF;
 SELECT count(*) INTO v_count FROM public.mock_tests WHERE id=v_test OR title=v_title;
 IF v_count>1 THEN RAISE EXCEPTION 'Conflicting test ID/title; refusing to modify existing data'; END IF;
 SELECT * INTO v_existing FROM public.mock_tests WHERE id=v_test OR title=v_title FOR UPDATE;
 IF FOUND THEN
  IF v_existing.id<>v_test OR v_existing.title NOT IN (v_title,v_legacy_title) OR v_existing.duration_minutes<>60 OR
     v_existing.total_marks<>200 OR v_existing.passing_marks<>0 OR
     v_existing.description IS DISTINCT FROM v_description OR v_existing.exam_type<>'OTHER' THEN
   RAISE EXCEPTION 'Existing test differs; refusing to overwrite';
  END IF;
  SELECT jsonb_agg(jsonb_build_object('id',q.id,'display_order',q.display_order,
    'question_text',q.question_text,'question_type',q.question_type,'options',q.options,
    'correct_answer',q.correct_answer,'marks',q.marks,'negative_marks',q.negative_marks,
    'explanation',q.explanation) ORDER BY q.display_order) INTO v_actual
  FROM public.mock_questions q WHERE q.mock_test_id=v_test;
  IF v_actual IS DISTINCT FROM v_payload THEN
   RAISE EXCEPTION 'Existing questions differ or are incomplete; refusing to overwrite attempt history';
  END IF;
  UPDATE public.mock_tests SET title=v_title WHERE id=v_test AND title=v_legacy_title;
  RAISE NOTICE 'Mock verified; title updated if needed (questions, attempts and publication state preserved).';
  RETURN;
 END IF;
 -- The catalogue recognises SSC CGL by title; do not attach this paper to an engineering branch.
 SELECT id INTO v_subject FROM public.subjects WHERE name='SSC CGL' ORDER BY id LIMIT 1;
 IF v_subject IS NULL AND EXISTS (SELECT 1 FROM information_schema.columns
   WHERE table_schema='public' AND table_name='mock_tests' AND column_name='subject_id' AND is_nullable='NO') THEN
  RAISE EXCEPTION 'subject_id is required; create/map an SSC CGL subject before importing';
 END IF;
 INSERT INTO public.mock_tests(id,title,description,exam_type,subject_id,duration_minutes,total_marks,passing_marks,is_published)
 VALUES(v_test,v_title,v_description,'OTHER',v_subject,60,200,0,FALSE);
 INSERT INTO public.mock_questions(id,mock_test_id,display_order,question_text,question_type,options,correct_answer,marks,negative_marks,explanation)
 SELECT q.id,v_test,q.display_order,q.question_text,q.question_type,q.options,q.correct_answer,q.marks,q.negative_marks,q.explanation
 FROM jsonb_to_recordset(v_payload) AS q(id UUID,display_order INT,question_text TEXT,question_type TEXT,options JSONB,correct_answer TEXT,marks NUMERIC,negative_marks NUMERIC,explanation TEXT);
 GET DIAGNOSTICS v_count=ROW_COUNT;
 IF v_count<>100 OR (SELECT sum(marks) FROM public.mock_questions WHERE mock_test_id=v_test)<>200 THEN
  RAISE EXCEPTION 'Import count/marks mismatch';
 END IF;
 RAISE NOTICE 'Created unpublished SSC CGL mock: 100 questions / 200 marks.';
END;
$seed$;
COMMIT;
