import 'dart:convert';

import 'package:cliniq/features/ai/data/models/scan_analysis_model.dart';
import 'package:cliniq/features/ai/domain/entities/scan_analysis_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScanAnalysisModel routing + parsing', () {
    test('PRESCRIPTION routes to prescription and keeps top-level fields', () {
      final result = ScanAnalysisModel.fromJson(_prescription);
      expect(result, isA<PrescriptionAnalysisEntity>());
      final p = result as PrescriptionAnalysisEntity;
      expect(p.id, 35);
      expect(p.patientName, 'oraby 21');
      expect(p.scanBase64, 'url');
      expect(p.modality, 'PRESCRIPTION');
      expect(p.aiJobStatus, 'Completed');
      expect(p.totalMedications, 3);
      expect(p.verifiedMedications, 1);
      expect(p.medications.length, 3);
      expect(p.medications.first.drugExtracted, 'Arcoxia');
      expect(p.rawMedications.length, 3);
      expect(p.primaryDiagnosis.isNotEmpty, true);
      expect(p.inputGate.passed, true);
    });

    test('rejected routes to rejected and keeps top-level fields', () {
      final result = ScanAnalysisModel.fromJson(_rejected);
      expect(result, isA<AIAnalysisRejectedEntity>());
      final r = result as AIAnalysisRejectedEntity;
      // Top-level fields used to be lost — assert they now survive.
      expect(r.modality, 'DENTAL_XRAY');
      expect(r.scanBase64, 'url');
      expect(r.patientName, 'mohamed eloraby');
      expect(r.aiJobStatus, 'Completed');
      // aiAnalysisResult fields.
      expect(r.urgency, 'REJECTED');
      expect(r.summary.isNotEmpty, true);
      expect(r.recommendations.length, 1);
      expect(r.inputGate.passed, false);
      expect(r.inputGate.reason.isNotEmpty, true);
      expect(r.inputGate.colorfulFraction, closeTo(0.794, 0.0001));
    });

    test('success routes to success and keeps top-level + findings fields', () {
      final result = ScanAnalysisModel.fromJson(_success);
      expect(result, isA<AIAnalysisSuccessEntity>());
      final s = result as AIAnalysisSuccessEntity;
      // Top-level fields that used to be lost.
      expect(s.id, 47);
      expect(s.patientName, 'mohamed elraby');
      expect(s.scanBase64, 'url');
      expect(s.modality, 'DENTAL_PHOTO');
      expect(s.aiJobId, '6ccea09fc89344e2bd288c8ca4898b9a');
      expect(s.aiJobStatus, 'Completed');
      // aiAnalysisResult + ai_findings.
      expect(s.primaryDiagnosis, 'Gingivitis');
      expect(s.confidence, '73.6%');
      expect(s.severity, 'MODERATE');
      expect(s.clinicalMeaning.isNotEmpty, true);
      expect(s.bodyPart, 'Oral cavity');
      expect(s.patientContext, 'Dental/oral examination image analysis');
      expect(s.urgency, 'ROUTINE');
      expect(s.findingsList.length, 2);
      expect(s.recommendations.length, 4);
      expect(s.allProbabilities.length, 6);
      expect(s.inputGate.passed, true);
      // Highest probability should be Gingivitis after sorting by the UI.
      final top = (List.of(s.allProbabilities)
            ..sort((a, b) => b.value.compareTo(a.value)))
          .first;
      expect(top.label, 'Gingivitis');
    });

    test('missing input_gate is treated as success, not rejected', () {
      final json = {
        'modality': 'DENTAL_PHOTO',
        'scanBase64': 'url',
        'aiAnalysisResult': {
          'ai_findings': {'primary_diagnosis': 'X', 'confidence': '10%'},
          'annotated_image_base64': '',
        },
      };
      expect(
        ScanAnalysisModel.fromJson(json),
        isA<AIAnalysisSuccessEntity>(),
      );
    });

    test('FLAT rejected (no aiAnalysisResult wrapper) still routes to rejected',
        () {
      final json = {
        'modality': 'DENTAL_XRAY',
        'scanBase64': 'url',
        'patientName': 'flat patient',
        'input_gate': {
          'passed': false,
          'reason': 'grayscale expected',
          'scores': {'width': 100, 'height': 200, 'colorful_fraction': 0.9},
        },
        'urgency': 'REJECTED',
        'summary': 'flat rejection summary',
        'recommendations': ['re-upload'],
      };
      final result = ScanAnalysisModel.fromJson(json);
      expect(result, isA<AIAnalysisRejectedEntity>());
      final r = result as AIAnalysisRejectedEntity;
      expect(r.modality, 'DENTAL_XRAY');
      expect(r.patientName, 'flat patient');
      expect(r.urgency, 'REJECTED');
      expect(r.summary, 'flat rejection summary');
      expect(r.recommendations.single, 're-upload');
      expect(r.inputGate.passed, false);
      expect(r.inputGate.reason, 'grayscale expected');
      expect(r.inputGate.colorfulFraction, closeTo(0.9, 0.0001));
    });

    test('FLAT success (no aiAnalysisResult wrapper) keeps its fields', () {
      final json = {
        'modality': 'DENTAL_PHOTO',
        'scanBase64': 'url',
        'input_gate': {'passed': true},
        'ai_findings': {'primary_diagnosis': 'Gingivitis', 'confidence': '80%'},
        'summary': 'flat success',
      };
      final result = ScanAnalysisModel.fromJson(json);
      expect(result, isA<AIAnalysisSuccessEntity>());
      final s = result as AIAnalysisSuccessEntity;
      expect(s.primaryDiagnosis, 'Gingivitis');
      expect(s.confidence, '80%');
      expect(s.summary, 'flat success');
    });

    test('passed as string "false" is still treated as rejected', () {
      final json = {
        'modality': 'DENTAL_XRAY',
        'aiAnalysisResult': {
          'input_gate': {'passed': 'false'},
          'summary': 's',
        },
      };
      expect(ScanAnalysisModel.fromJson(json), isA<AIAnalysisRejectedEntity>());
    });

    test('passed as number 0 is still treated as rejected', () {
      final json = {
        'modality': 'DENTAL_XRAY',
        'aiAnalysisResult': {
          'input_gate': {'passed': 0},
        },
      };
      expect(ScanAnalysisModel.fromJson(json), isA<AIAnalysisRejectedEntity>());
    });

    test('STRINGIFIED aiAnalysisResult (double-encoded) rejected routes '
        'correctly and keeps fields', () {
      final json = {
        'modality': 'DENTAL_XRAY',
        'scanBase64': 'url',
        'patientName': 'mohamed eloraby',
        'aiAnalysisResult': jsonEncode({
          'input_rejected': true,
          'input_gate': {
            'passed': false,
            'reason': 'image is in colour',
            'scores': {'width': 612, 'height': 408, 'colorful_fraction': 0.794},
          },
          'urgency': 'REJECTED',
          'summary': 'Input rejected by quality gate',
          'recommendations': ['Please upload a valid dental xray image.'],
        }),
      };
      final result = ScanAnalysisModel.fromJson(json);
      expect(result, isA<AIAnalysisRejectedEntity>());
      final r = result as AIAnalysisRejectedEntity;
      expect(r.modality, 'DENTAL_XRAY');
      expect(r.patientName, 'mohamed eloraby');
      expect(r.urgency, 'REJECTED');
      expect(r.summary, 'Input rejected by quality gate');
      expect(r.inputGate.passed, false);
      expect(r.inputGate.reason, 'image is in colour');
      expect(r.inputGate.colorfulFraction, closeTo(0.794, 0.0001));
    });

    test('STRINGIFIED aiAnalysisResult success routes correctly and keeps '
        'findings', () {
      final json = {
        'modality': 'DENTAL_PHOTO',
        'scanBase64': 'url',
        'aiAnalysisResult': jsonEncode({
          'input_gate': {'passed': true},
          'ai_findings': {
            'primary_diagnosis': 'Gingivitis',
            'confidence': '73.6%',
            'severity': 'MODERATE',
          },
          'summary': 'AI analysis detected gingivitis',
          'all_probabilities': {'Gingivitis': 0.736, 'Calculus': 0.264},
        }),
      };
      final result = ScanAnalysisModel.fromJson(json);
      expect(result, isA<AIAnalysisSuccessEntity>());
      final s = result as AIAnalysisSuccessEntity;
      expect(s.primaryDiagnosis, 'Gingivitis');
      expect(s.confidence, '73.6%');
      expect(s.severity, 'MODERATE');
      expect(s.allProbabilities.length, 2);
    });

    test('DEEP-nested input_gate.passed=false is still detected as rejected',
        () {
      final json = {
        'modality': 'DENTAL_XRAY',
        'aiAnalysisResult': jsonEncode({
          'meta': {
            'quality': {
              'input_gate': {'passed': false, 'reason': 'nested deep'},
            },
          },
        }),
      };
      expect(ScanAnalysisModel.fromJson(json), isA<AIAnalysisRejectedEntity>());
    });

    test('STRINGIFIED aiAnalysisResult prescription routes and parses meds', () {
      final json = {
        'modality': 'PRESCRIPTION',
        'scanBase64': 'url',
        'aiAnalysisResult': jsonEncode({
          'ai_findings': {
            'primary_diagnosis': 'extracted meds',
            'notes': 'verified',
          },
          'report_data': {
            'total_medications': 2,
            'verified_medications': 1,
            'medications': [
              {'drug': 'a', 'dosage': '1', 'frequency': 'x',
                'schedule_ar': '', 'confidence_score': 90, 'official_match': true},
              {'drug': 'b', 'dosage': '2', 'frequency': 'y',
                'schedule_ar': '', 'confidence_score': 80, 'official_match': false},
            ],
          },
          'input_gate': {'passed': true},
        }),
      };
      final result = ScanAnalysisModel.fromJson(json);
      expect(result, isA<PrescriptionAnalysisEntity>());
      final p = result as PrescriptionAnalysisEntity;
      expect(p.totalMedications, 2);
      expect(p.verifiedMedications, 1);
      expect(p.medications.length, 2);
      expect(p.primaryDiagnosis, 'extracted meds');
    });
  });
}

final Map<String, dynamic> _prescription = {
  'id': 35,
  'patientId': '774624ac-1003-41d2-b0e8-b8f603d7df05',
  'patientName': 'oraby 21',
  'modality': 'PRESCRIPTION',
  'scanUrl': null,
  'scanBase64': 'url',
  'aiJobId': '2ddbccd7e6c94d1c861ea7a1cea729cc',
  'aiJobStatus': 'Completed',
  'aiAnalysisResult': {
    'success': true,
    'image_type': 'prescription',
    'detections': [],
    'ai_findings': {
      'primary_diagnosis': 'تم استخراج 3 دواء من الروشتة',
      'medications': [
        {
          'drug_extracted': 'Arcoxia',
          'drug': 'arcoxia',
          'dosage': '90 tab',
          'frequency': 'بعد الفذاء',
          'schedule_ar': 'غير واضح',
          'schedule_source': 'unknown',
          'confidence_score': 100.0,
          'official_match': true,
        },
        {
          'drug_extracted': 'Colchicine',
          'drug': 'Colchicine',
          'dosage': '0.5 tab',
          'frequency': 'بعد الإفطار والعشاء',
          'schedule_ar': 'مساء',
          'schedule_source': 'explicit',
          'confidence_score': 90.0,
          'official_match': false,
        },
        {
          'drug_extracted': 'Uralyt U Granules',
          'drug': 'Uralyt U Granules',
          'dosage': '1 tab',
          'frequency': 'بعد الإفطار والعشاء',
          'schedule_ar': 'مساء',
          'schedule_source': 'explicit',
          'confidence_score': 90.0,
          'official_match': false,
        },
      ],
      'raw_vlm_output':
          '[{"drug":"Arcoxia","dosage":"90 tab","frequency":"بعد الفذاء"}]',
      'notes': 'Parsed and verified against Egyptian medicines dataset.',
    },
    'report_data': {
      'total_medications': 3,
      'verified_medications': 1,
      'medications': [
        {
          'drug_extracted': 'Arcoxia',
          'drug': 'arcoxia',
          'dosage': '90 tab',
          'frequency': 'بعد الفذاء',
          'schedule_ar': 'غير واضح',
          'schedule_source': 'unknown',
          'confidence_score': 100.0,
          'official_match': true,
        },
        {
          'drug_extracted': 'Colchicine',
          'drug': 'Colchicine',
          'dosage': '0.5 tab',
          'frequency': 'بعد الإفطار والعشاء',
          'schedule_ar': 'مساء',
          'schedule_source': 'explicit',
          'confidence_score': 90.0,
          'official_match': false,
        },
        {
          'drug_extracted': 'Uralyt U Granules',
          'drug': 'Uralyt U Granules',
          'dosage': '1 tab',
          'frequency': 'بعد الإفطار والعشاء',
          'schedule_ar': 'مساء',
          'schedule_source': 'explicit',
          'confidence_score': 90.0,
          'official_match': false,
        },
      ],
    },
    'input_gate': {
      'passed': true,
      'action': 'accept',
      'reason': null,
      'scores': {
        'width': 669,
        'height': 670,
        'aspect_ratio': 1.0,
        'intensity_std': 50.55,
        'color_spread': 32.92,
        'colorful_fraction': 0.938,
      },
    },
  },
  'doctorId': null,
  'doctorName': null,
  'doctorNotes': null,
  'doctorReviewDate': null,
  'isReviewed': false,
  'createdAt': '2026-07-13T15:19:07.6210642',
};

final Map<String, dynamic> _rejected = {
  'id': 49,
  'patientId': 'ff31ff60-6190-402f-a237-d0399fb15521',
  'patientName': 'mohamed eloraby',
  'modality': 'DENTAL_XRAY',
  'scanUrl': null,
  'scanBase64': 'url',
  'aiJobId': '31f512a556fe444b85fec9b73d9dfe15',
  'aiJobStatus': 'Completed',
  'aiAnalysisResult': {
    'modality': 'dental_xray',
    'input_rejected': true,
    'input_gate': {
      'passed': false,
      'action': 'reject',
      'reason':
          'image is in colour (79% coloured pixels); a dental xray X-ray should be grayscale',
      'scores': {
        'width': 612,
        'height': 408,
        'aspect_ratio': 1.5,
        'intensity_std': 71.88,
        'color_spread': 77.16,
        'colorful_fraction': 0.794,
      },
    },
    'urgency': 'REJECTED',
    'detections': [],
    'summary':
        'Input rejected by quality gate: image is in colour (79% coloured pixels)',
    'recommendations': ['Please upload a valid dental xray image.'],
  },
  'doctorId': null,
  'doctorName': null,
  'doctorNotes': null,
  'doctorReviewDate': null,
  'isReviewed': false,
  'createdAt': '2026-07-13T22:25:44.8845251',
};

final Map<String, dynamic> _success = {
  'id': 47,
  'patientId': 'a9dbbdca-0ce5-4c77-8306-f9ddc3f01d08',
  'patientName': 'mohamed elraby',
  'modality': 'DENTAL_PHOTO',
  'scanUrl': null,
  'scanBase64': 'url',
  'aiJobId': '6ccea09fc89344e2bd288c8ca4898b9a',
  'aiJobStatus': 'Completed',
  'aiAnalysisResult': {
    'patient_context': 'Dental/oral examination image analysis',
    'modality': 'Intraoral photograph',
    'body_part': 'Oral cavity',
    'annotated_image_base64': 'url',
    'detections': [],
    'ai_findings': {
      'primary_diagnosis': 'Gingivitis',
      'confidence': '73.6%',
      'severity': 'MODERATE',
      'clinical_meaning':
          'gingival inflammation indicating early periodontal disease',
    },
    'differential_diagnoses': [],
    'all_probabilities': {
      'Calculus': 0.26398852467536926,
      'Caries': 2.3024013273698074e-07,
      'Discoloration': 1.7319764538115123e-06,
      'Gingivitis': 0.7360086441040039,
      'Hypodontia': 8.007978067325894e-07,
      'Ulcer': 3.7105080119559375e-10,
    },
    'urgency': 'ROUTINE',
    'findings': [
      'GINGIVITIS detected with 73.6% confidence',
      'Clinical significance: gingival inflammation',
    ],
    'recommendations': [
      'Professional dental cleaning recommended',
      'Improved oral hygiene practices advised',
      'Follow-up to assess treatment response',
      'Consider periodontal evaluation if persistent',
    ],
    'summary': 'AI analysis detected gingivitis with 73.6% confidence.',
    'timestamp': '2026-07-13T17:42:13.256105',
    'input_gate': {
      'passed': true,
      'action': 'accept',
      'reason': null,
      'scores': {
        'width': 612,
        'height': 408,
        'aspect_ratio': 1.5,
        'intensity_std': 71.88,
        'color_spread': 77.16,
        'colorful_fraction': 0.794,
      },
    },
  },
  'doctorId': null,
  'doctorName': null,
  'doctorNotes': null,
  'doctorReviewDate': null,
  'isReviewed': false,
  'createdAt': '2026-07-13T21:42:10.4919473',
};
