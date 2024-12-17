import 'dart:io' show Platform;

// iOS 스타일의 인터페이스 요소를 사용하기 위해 Cupertino 디자인 패키지를 임포트합니다.
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

// Android 및 기본 플랫폼 스타일의 인터페이스 요소를 사용하기 위해 Material 디자인 패키지를 임포트합니다.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 상태 관리를 위해 사용되는 Riverpod 패키지를 임포트합니다.
// Riverpod는 애플리케이션의 다양한 상태를 관리하는 데 도움을 주는 강력한 도구입니다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

// 애플리케이션에서 사용할 색상 상수들을 정의한 파일을 임포트합니다.
import '../../common/const/colors.dart';

// 제품 데이터 모델을 정의한 파일을 임포트합니다.
// 이 모델은 제품의 속성을 정의하고, 애플리케이션에서 제품 데이터를 구조화하는 데 사용됩니다.
import '../../common/layout/common_body_parts_layout.dart';

// aaa 파일
import '../../market/aaa/product/view/detail_screen/aaa_blouse_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_cardigan_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_coat_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_jean_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_mtm_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_neat_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_onepiece_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_paeding_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_pants_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_pola_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_shirt_detail_screen.dart';
import '../../market/aaa/product/view/detail_screen/aaa_skirt_detail_screen.dart';

// aab 파일
import '../../market/aab/product/view/detail_screen/aab_blouse_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_cardigan_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_coat_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_jean_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_mtm_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_neat_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_onepiece_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_paeding_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_pants_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_pola_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_shirt_detail_screen.dart';
import '../../market/aab/product/view/detail_screen/aab_skirt_detail_screen.dart';

// aac 파일
import '../../market/aac/product/view/detail_screen/aac_blouse_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_cardigan_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_coat_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_jean_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_mtm_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_neat_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_onepiece_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_paeding_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_pants_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_pola_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_shirt_detail_screen.dart';
import '../../market/aac/product/view/detail_screen/aac_skirt_detail_screen.dart';

// aad 파일
import '../../market/aad/product/view/detail_screen/aad_blouse_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_cardigan_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_coat_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_jean_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_mtm_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_neat_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_onepiece_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_paeding_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_pants_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_pola_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_shirt_detail_screen.dart';
import '../../market/aad/product/view/detail_screen/aad_skirt_detail_screen.dart';

// aae 파일
import '../../market/aae/product/view/detail_screen/aae_blouse_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_cardigan_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_coat_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_jean_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_mtm_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_neat_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_onepiece_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_paeding_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_pants_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_pola_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_shirt_detail_screen.dart';
import '../../market/aae/product/view/detail_screen/aae_skirt_detail_screen.dart';

// aaf 파일
import '../../market/aaf/product/view/detail_screen/aaf_blouse_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_cardigan_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_coat_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_jean_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_mtm_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_neat_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_onepiece_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_paeding_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_pants_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_pola_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_shirt_detail_screen.dart';
import '../../market/aaf/product/view/detail_screen/aaf_skirt_detail_screen.dart';

// aag 파일
import '../../market/aag/product/view/detail_screen/aag_blouse_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_cardigan_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_coat_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_jean_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_mtm_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_neat_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_onepiece_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_paeding_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_pants_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_pola_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_shirt_detail_screen.dart';
import '../../market/aag/product/view/detail_screen/aag_skirt_detail_screen.dart';

// aah 파일
import '../../market/aah/product/view/detail_screen/aah_blouse_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_cardigan_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_coat_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_jean_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_mtm_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_neat_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_onepiece_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_paeding_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_pants_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_pola_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_shirt_detail_screen.dart';
import '../../market/aah/product/view/detail_screen/aah_skirt_detail_screen.dart';

// aai 파일
import '../../market/aai/product/view/detail_screen/aai_blouse_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_cardigan_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_coat_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_jean_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_mtm_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_neat_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_onepiece_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_paeding_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_pants_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_pola_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_shirt_detail_screen.dart';
import '../../market/aai/product/view/detail_screen/aai_skirt_detail_screen.dart';

// aaj 파일
import '../../market/aaj/product/view/detail_screen/aaj_blouse_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_cardigan_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_coat_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_jean_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_mtm_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_neat_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_onepiece_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_paeding_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_pants_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_pola_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_shirt_detail_screen.dart';
import '../../market/aaj/product/view/detail_screen/aaj_skirt_detail_screen.dart';

// aak 파일
import '../../market/aak/product/view/detail_screen/aak_blouse_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_cardigan_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_coat_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_jean_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_mtm_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_neat_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_onepiece_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_paeding_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_pants_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_pola_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_shirt_detail_screen.dart';
import '../../market/aak/product/view/detail_screen/aak_skirt_detail_screen.dart';

// aal 파일
import '../../market/aal/product/view/detail_screen/aal_blouse_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_cardigan_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_coat_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_jean_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_mtm_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_neat_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_onepiece_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_paeding_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_pants_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_pola_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_shirt_detail_screen.dart';
import '../../market/aal/product/view/detail_screen/aal_skirt_detail_screen.dart';

// aam 파일
import '../../market/aam/product/view/detail_screen/aam_blouse_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_cardigan_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_coat_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_jean_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_mtm_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_neat_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_onepiece_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_paeding_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_pants_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_pola_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_shirt_detail_screen.dart';
import '../../market/aam/product/view/detail_screen/aam_skirt_detail_screen.dart';

// aan 파일
import '../../market/aan/product/view/detail_screen/aan_blouse_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_cardigan_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_coat_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_jean_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_mtm_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_neat_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_onepiece_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_paeding_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_pants_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_pola_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_shirt_detail_screen.dart';
import '../../market/aan/product/view/detail_screen/aan_skirt_detail_screen.dart';

// aao 파일
import '../../market/aao/product/view/detail_screen/aao_blouse_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_cardigan_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_coat_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_jean_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_mtm_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_neat_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_onepiece_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_paeding_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_pants_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_pola_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_shirt_detail_screen.dart';
import '../../market/aao/product/view/detail_screen/aao_skirt_detail_screen.dart';

// aap 파일
import '../../market/aap/product/view/detail_screen/aap_blouse_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_cardigan_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_coat_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_jean_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_mtm_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_neat_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_onepiece_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_paeding_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_pants_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_pola_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_shirt_detail_screen.dart';
import '../../market/aap/product/view/detail_screen/aap_skirt_detail_screen.dart';

// aaq 파일
import '../../market/aaq/product/view/detail_screen/aaq_blouse_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_cardigan_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_coat_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_jean_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_mtm_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_neat_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_onepiece_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_paeding_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_pants_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_pola_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_shirt_detail_screen.dart';
import '../../market/aaq/product/view/detail_screen/aaq_skirt_detail_screen.dart';

// aar 파일
import '../../market/aar/product/view/detail_screen/aar_blouse_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_cardigan_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_coat_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_jean_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_mtm_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_neat_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_onepiece_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_paeding_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_pants_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_pola_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_shirt_detail_screen.dart';
import '../../market/aar/product/view/detail_screen/aar_skirt_detail_screen.dart';

// aas 파일
import '../../market/aas/product/view/detail_screen/aas_blouse_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_cardigan_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_coat_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_jean_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_mtm_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_neat_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_onepiece_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_paeding_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_pants_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_pola_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_shirt_detail_screen.dart';
import '../../market/aas/product/view/detail_screen/aas_skirt_detail_screen.dart';

// aat 파일
import '../../market/aat/product/view/detail_screen/aat_blouse_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_cardigan_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_coat_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_jean_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_mtm_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_neat_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_onepiece_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_paeding_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_pants_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_pola_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_shirt_detail_screen.dart';
import '../../market/aat/product/view/detail_screen/aat_skirt_detail_screen.dart';

// aau 파일
import '../../market/aau/product/view/detail_screen/aau_blouse_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_cardigan_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_coat_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_jean_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_mtm_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_neat_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_onepiece_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_paeding_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_pants_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_pola_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_shirt_detail_screen.dart';
import '../../market/aau/product/view/detail_screen/aau_skirt_detail_screen.dart';

// aav 파일
import '../../market/aav/product/view/detail_screen/aav_blouse_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_cardigan_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_coat_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_jean_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_mtm_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_neat_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_onepiece_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_paeding_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_pants_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_pola_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_shirt_detail_screen.dart';
import '../../market/aav/product/view/detail_screen/aav_skirt_detail_screen.dart';

// aaw 파일
import '../../market/aaw/product/view/detail_screen/aaw_blouse_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_cardigan_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_coat_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_jean_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_mtm_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_neat_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_onepiece_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_paeding_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_pants_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_pola_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_shirt_detail_screen.dart';
import '../../market/aaw/product/view/detail_screen/aaw_skirt_detail_screen.dart';

// aax 파일
import '../../market/aax/product/view/detail_screen/aax_blouse_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_cardigan_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_coat_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_jean_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_mtm_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_neat_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_onepiece_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_paeding_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_pants_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_pola_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_shirt_detail_screen.dart';
import '../../market/aax/product/view/detail_screen/aax_skirt_detail_screen.dart';

// aay 파일
import '../../market/aay/product/view/detail_screen/aay_blouse_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_cardigan_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_coat_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_jean_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_mtm_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_neat_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_onepiece_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_paeding_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_pants_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_pola_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_shirt_detail_screen.dart';
import '../../market/aay/product/view/detail_screen/aay_skirt_detail_screen.dart';

// aaz 파일
import '../../market/aaz/product/view/detail_screen/aaz_blouse_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_cardigan_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_coat_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_jean_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_mtm_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_neat_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_onepiece_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_paeding_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_pants_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_pola_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_shirt_detail_screen.dart';
import '../../market/aaz/product/view/detail_screen/aaz_skirt_detail_screen.dart';

// aba 파일
import '../../market/aba/product/view/detail_screen/aba_blouse_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_cardigan_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_coat_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_jean_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_mtm_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_neat_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_onepiece_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_paeding_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_pants_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_pola_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_shirt_detail_screen.dart';
import '../../market/aba/product/view/detail_screen/aba_skirt_detail_screen.dart';

// abb 파일
import '../../market/abb/product/view/detail_screen/abb_blouse_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_cardigan_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_coat_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_jean_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_mtm_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_neat_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_onepiece_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_paeding_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_pants_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_pola_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_shirt_detail_screen.dart';
import '../../market/abb/product/view/detail_screen/abb_skirt_detail_screen.dart';

// abc 파일
import '../../market/abc/product/view/detail_screen/abc_blouse_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_cardigan_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_coat_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_jean_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_mtm_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_neat_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_onepiece_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_paeding_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_pants_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_pola_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_shirt_detail_screen.dart';
import '../../market/abc/product/view/detail_screen/abc_skirt_detail_screen.dart';

// abd 파일
import '../../market/abd/product/view/detail_screen/abd_blouse_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_cardigan_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_coat_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_jean_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_mtm_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_neat_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_onepiece_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_paeding_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_pants_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_pola_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_shirt_detail_screen.dart';
import '../../market/abd/product/view/detail_screen/abd_skirt_detail_screen.dart';

import '../../wishlist/layout/wishlist_body_parts_layout.dart';
import '../model/product_model.dart';

// 제품 상태 관리를 위한 StateProvider 파일을 임포트합니다.
import '../provider/product_state_provider.dart';

// 각 의류 카테고리에 대한 상세 화면 구현 파일들을 임포트합니다.
// 이 파일들은 각 카테고리별 제품의 상세 정보를 표시하는 화면을 정의합니다.
import '../view/product_detail_original_image_screen.dart';


// ------ pageViewWithArrows 위젯 내용 구현 시작
// PageView와 화살표 버튼을 포함하는 위젯
// 사용자가 페이지를 넘길 수 있도록 함.
Widget pageViewWithArrows(
  BuildContext context,
  PageController pageController, // 페이지 전환을 위한 컨트롤러
  WidgetRef ref, // Riverpod 상태 관리를 위한 ref
  StateProvider<int> currentPageProvider, {
  // 현재 페이지 인덱스를 관리하기 위한 StateProvider
  required IndexedWidgetBuilder itemBuilder, // 각 페이지를 구성하기 위한 함수
  required int itemCount, // 전체 페이지 수
}) {
  int currentPage = ref.watch(currentPageProvider); // 현재 페이지 인덱스를 관찰
  return Stack(
    alignment: Alignment.center,
    children: [
      PageView.builder(
        controller: pageController, // 페이지 컨트롤러 할당
        itemCount: itemCount, // 페이지 수 설정
        onPageChanged: (index) {
          ref.read(currentPageProvider.notifier).state =
              index; // 페이지가 변경될 때마다 인덱스 업데이트
        },
        itemBuilder: itemBuilder, // 페이지를 구성하는 위젯을 생성
      ),
      // 왼쪽 화살표 버튼. 첫 페이지가 아닐 때만 활성화됩니다.
      arrowButton(
          context,
          Icons.arrow_back_ios,
          currentPage > 0,
          () => pageController.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
          currentPageProvider,
          ref),
      // 오른쪽 화살표 버튼. 마지막 페이지가 아닐 때만 활성화됩니다.
      // 현재 페이지 < 전체 페이지 수 - 1 의 조건으로 변경하여 마지막 페이지 검사를 보다 정확하게 합니다.
      arrowButton(
          context,
          Icons.arrow_forward_ios,
          currentPage < itemCount - 1,
          () => pageController.nextPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
          currentPageProvider,
          ref),
    ],
  );
}
// ------ pageViewWithArrows 위젯 내용 구현 끝

// ------ arrowButton 위젯 내용 구현 시작
// 화살표 버튼을 생성하는 위젯(함수)
// 화살표 버튼을 통해 사용자는 페이지를 앞뒤로 넘길 수 있음.
Widget arrowButton(
    BuildContext context,
    IconData icon,
    bool isActive,
    VoidCallback onPressed,
    StateProvider<int> currentPageProvider,
    WidgetRef ref) {
  return Positioned(
    left: icon == Icons.arrow_back_ios ? 10 : null, // 왼쪽 화살표 위치 조정
    right: icon == Icons.arrow_forward_ios ? 10 : null, // 오른쪽 화살표 위치 조정
    child: IconButton(
      icon: Icon(icon),
      color: isActive ? Colors.black : Colors.grey, // 활성화 여부에 따라 색상 변경
      onPressed: isActive ? onPressed : null, // 활성화 상태일 때만 동작
    ),
  );
}
// ------ arrowButton 위젯 내용 구현 끝

// ------ buildHorizontalDocumentsList 위젯 내용 구현 시작
// 주로, 홈 화면 내 2차 카테고리별 섹션 내 데이터를 스크롤뷰로 UI 구현하는 부분 관련 로직
// buildHorizontalDocumentsList 함수에서 Document 클릭 시 동작 추가
// 가로로 스크롤 가능한 문서 리스트를 생성하는 함수. 문서 클릭 시 설정된 동작을 실행함.
Widget buildHorizontalDocumentsList(
    WidgetRef ref,
    List<ProductContent> products,
    BuildContext context,
    String category,
    ScrollController horizontalScrollViewScrollController) {
  // ProductInfoDetailScreenNavigation 클래스 인스턴스를 생성하여 제품 정보 상세 화면 네비게이션을 설정함.
  final productInfo = ProductInfoDetailScreenNavigation(ref);

  return NotificationListener<ScrollNotification>(
    // 스크롤 알림 리스너를 추가함
    onNotification: (scrollNotification) {
      // debugPrint('Scroll notification: ${scrollNotification.metrics.pixels}');
      return false; // 스크롤 알림 수신시 false 반환하여 기본 동작 유지
    },
    child: SingleChildScrollView(
      // SingleChildScrollView를 사용하여 스크롤 가능한 영역을 생성함
      controller: horizontalScrollViewScrollController, // 가로 스크롤 컨트롤러 설정
      scrollDirection: Axis.horizontal, // 스크롤 방향을 가로로 설정
      child: Row(
        // Row 위젯을 사용하여 가로로 나열된 문서 리스트를 생성함
        children: products
            .map((product) => productInfo.buildProdFirestoreDetailDocument(
                context, product, ref))
            .toList(),
        // 각 제품에 대해 buildProdFirestoreDetailDocument 함수를 호출하여 위젯을 생성하고 리스트에 추가함
      ),
    ),
  );
}
// ------ buildHorizontalDocumentsList 위젯 내용 구현 끝

// -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 시작
// 홈 화면과 2차 메인화면(1차 카테고리별 메인화면)에 주로 사용될 예정
// 상품별 간단하게 데이터를 보여주는 UI 부분과 해당 상품 클릭 시, 상품 상세화면으로 이동하도록 하는 로직
class ProductInfoDetailScreenNavigation {
  final WidgetRef ref; // 상태 관리를 위해 사용되는 ref

  ProductInfoDetailScreenNavigation(this.ref);

  void navigateToDetailScreen(BuildContext context, ProductContent product) {
    Widget detailScreen;
    String appBarTitle;

    String docIdPrefix = product.docId.substring(0, 3);

    switch (product.category) {
      case "티셔츠":
        appBarTitle = '티셔츠 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "블라우스":
        appBarTitle = '블라우스 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaBlouseDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "가디건":
        appBarTitle = '가디건 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaCardiganDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "코트":
        appBarTitle = '코트 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaCoatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "청바지":
        appBarTitle = '청바지 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaJeanDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "맨투맨":
        appBarTitle = '맨투맨 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaMtmDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "니트":
        appBarTitle = '니트 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaNeatDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "원피스":
        appBarTitle = '원피스 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaOnepieceDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "아우터":
        appBarTitle = '아우터 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaePaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaPaedingDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "팬츠":
        appBarTitle = '팬츠 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaePantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaPantsDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "폴라티":
        appBarTitle = '폴라티 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaePolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AayPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaPolaDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      case "스커트":
        appBarTitle = '스커트 상세';
        if (docIdPrefix == 'Aaa') {
          detailScreen = AaaSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aab') {
          detailScreen = AabSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aac') {
          detailScreen = AacSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aad') {
          detailScreen = AadSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aae') {
          detailScreen = AaeSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaf') {
          detailScreen = AafSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aag') {
          detailScreen = AagSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aah') {
          detailScreen = AahSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aai') {
          detailScreen = AaiSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaj') {
          detailScreen = AajSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aak') {
          detailScreen = AakSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aal') {
          detailScreen = AalSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aam') {
          detailScreen = AamSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aan') {
          detailScreen = AanSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aao') {
          detailScreen = AaoSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aap') {
          detailScreen = AapSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaq') {
          detailScreen = AaqSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aar') {
          detailScreen = AarSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aas') {
          detailScreen = AasSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aat') {
          detailScreen = AatSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aau') {
          detailScreen = AauSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aav') {
          detailScreen = AavSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaw') {
          detailScreen = AawSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aax') {
          detailScreen = AaxSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aay') {
          detailScreen = AaySkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aaz') {
          detailScreen = AazSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Aba') {
          detailScreen = AbaSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abb') {
          detailScreen = AbbSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abc') {
          detailScreen = AbcSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else if (docIdPrefix == 'Abd') {
          detailScreen = AbdSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        } else {
          detailScreen = AaaSkirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
        }
        break;

      default:
        appBarTitle = '티셔츠 상세';
        detailScreen = AaaShirtDetailProductScreen(fullPath: product.docId, title: appBarTitle);
    }

    debugPrint('문서: ${product.docId}에 대한 $appBarTitle 화면으로 이동 중입니다.');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => detailScreen),
    ).then((_) {
      // 화면 복귀 시 상태 초기화
      ref.read(colorSelectionIndexProvider.notifier).state = 0;
      ref.read(colorSelectionTextProvider.notifier).state = null;
      ref.read(colorSelectionUrlProvider.notifier).state = null;
      ref.read(sizeSelectionIndexProvider.notifier).state = null;
      ref.read(detailQuantityIndexProvider.notifier).state = 1;
      ref.read(prodDetailScreenTabSectionProvider.notifier).state = ProdDetailScreenTabSection.productInfo;
    });
  }

  // Firestore에서 상세한 문서 정보를 빌드하여 UI에 구현하는 위젯.
  Widget buildProdFirestoreDetailDocument(
      BuildContext context, ProductContent product, WidgetRef ref) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 신상 섹션 내 요소들의 수치
    final double DetailDocWidth =
        screenSize.width * (160 / referenceWidth); // 가로 비율
    final double DetailDocThumnailWidth =
        screenSize.width * (152 / DetailDocWidth); // 가로 비율
    final double DetailDoc1X = screenSize.width * (6 / referenceWidth);
    final double DetailDoc2X = screenSize.width * (2 / referenceWidth);
    final double DetailDoc3X = screenSize.width * (4 / referenceWidth);
    final double DetailDoc4X = screenSize.width * (-9 / referenceWidth);
    final double DetailDoc1Y = screenSize.height * (6 / referenceHeight);
    final double DetailDoc2Y = screenSize.height * (2 / referenceHeight);
    final double DetailDoc3Y = screenSize.height * (-11 / referenceHeight);
    final double DetailDocTextFontSize1 =
        screenSize.height * (16 / referenceHeight);
    final double DetailDocTextFontSize2 =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocTextFontSize3 =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocTextFontSize4 =
        screenSize.height * (14 / referenceHeight);
    final double DetailDocColorImageWidth =
        screenSize.height * (12 / referenceHeight);
    final double DetailDocColorImageHeight =
        screenSize.height * (12 / referenceHeight);

    final double interval1Y = screenSize.height * (4 / referenceHeight);
    final double interval1X = screenSize.width * (6 / referenceWidth);
    final double interval2X = screenSize.width * (100 / referenceWidth);
    final double interval2Y = screenSize.height * (110 / referenceHeight);

    // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
    final numberFormat = NumberFormat('###,###');

    return GestureDetector(
      // 문서 클릭 시 navigateToDetailScreen 함수를 호출함.
      onTap: () {
        navigateToDetailScreen(
            context, product); // product.docId를 사용하여 해당 문서로 이동함.
      },
      child: Container(
        // 높이를 명시적으로 지정하여 충분한 공간 확보
        width: DetailDocWidth,
        padding: EdgeInsets.all(DetailDoc3X),
        margin: EdgeInsets.all(DetailDoc3X),
        decoration: BoxDecoration(
          // 컨테이너의 배경색을 흰색으로 설정하고 둥근 모서리 및 그림자 효과를 추가함
          color: WHITE_COLOR,
          borderRadius: BorderRadius.circular(10.0),
          border: Border(
            top: BorderSide(color: GRAY77_COLOR, width: 1.0),
            // 상단 테두리 색상을 설정함
            bottom: BorderSide(color: GRAY77_COLOR, width: 1.0),
            // 하단 테두리 색상을 설정함
            left: BorderSide(color: GRAY77_COLOR, width: 1.0),
            // 좌측 테두리 색상을 설정함
            right:
                BorderSide(color: GRAY77_COLOR, width: 1.0), // 우측 테두리 색상을 설정함
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 제품 썸네일을 표시함.
                // 썸네일이 null이 아니고 빈 문자열이 아닐 때만 실행
                // 썸네일을 가운데 정렬
                Center(
                  // 썸네일 이미지와 좋아요 아이콘을 겹쳐서 표시
                  child: Stack(
                    children: [
                      // 썸네일이 있으면 이미지를 표시하고, 없으면 아이콘을 표시
                      product.thumbnail != null && product.thumbnail!.isNotEmpty
                          // 네트워크에서 이미지를 가져와서 표시
                          // 아이콘 버튼을 이미지 위에 겹쳐서 위치시킴
                          ? Image.network(
                              product.thumbnail!,
                              width: DetailDocThumnailWidth,
                              fit: BoxFit.cover,
                              // 이미지 로드 실패 시 아이콘 표시
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                Icons.image_not_supported,
                                color: GRAY88_COLOR,
                                size: interval2X,
                              ),
                            )
                          : Icon(
                              Icons.image_not_supported,
                              color: GRAY88_COLOR,
                              size: interval2X,
                            ), // 썸네일이 없을 때 아이콘을 표시
                      // 위젯을 위치시키는 클래스, 상위 위젯의 특정 위치에 자식 위젯을 배치함
                      Positioned(
                        top: DetailDoc3Y,
                        // 자식 위젯을 상위 위젯의 위쪽 경계에서 -10 만큼 떨어뜨림 (위로 10 이동)
                        right: DetailDoc4X,
                        // 자식 위젯을 상위 위젯의 오른쪽 경계에서 -10 만큼 떨어뜨림 (왼쪽으로 10 이동)
                        // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                        child: WishlistIconButton(
                          product: product, // 'product' 파라미터를 전달
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: interval1Y),
                // 제품 간단한 소개를 표시함.
                if (product.briefIntroduction != null &&
                    product.briefIntroduction!.isNotEmpty)
                  Padding(
                    padding:
                        EdgeInsets.only(left: DetailDoc1X, top: DetailDoc1Y),
                    child: Text(
                      product.briefIntroduction!,
                      style: TextStyle(
                        fontSize: DetailDocTextFontSize1,
                        color: BLACK_COLOR, // 텍스트 색상
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2, // 최대 2줄까지 표시함.
                      overflow: TextOverflow.visible, // 넘치는 텍스트는 '...'으로 표시함.
                    ),
                  ),
                SizedBox(height: interval1Y),
                // 원래 가격을 표시함. 소수점은 표시하지 않음.
                if (product.originalPrice != null)
                  Padding(
                    padding:
                        EdgeInsets.only(left: DetailDoc1X, top: DetailDoc2Y),
                    child: Row(
                      children: [
                        Text(
                          product.originalPrice != null
                              ? '${numberFormat.format(product.originalPrice!)}원'
                              : '',
                          style: TextStyle(
                              fontSize: DetailDocTextFontSize2,
                              color: GRAY42_COLOR,
                              // 텍스트 색상
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough),
                        ),
                        SizedBox(width: interval1X),
                        // 할인율을 빨간색으로 표시함.
                        if (product.discountPercent != null)
                          Text(
                            product.discountPercent != null
                                ? '${numberFormat.format(product.discountPercent!)}%'
                                : '',
                            style: TextStyle(
                              fontSize: DetailDocTextFontSize3,
                              color: RED46_COLOR, // 텍스트 색상
                              fontFamily: 'NanumGothic',
                              fontWeight: FontWeight.w800, // ExtraBold로 설정
                            ),
                          ),
                      ],
                    ),
                  ),
                // 할인된 가격을 표시함. 소수점은 표시하지 않음.
                if (product.discountPrice != null)
                  Padding(
                    padding:
                        EdgeInsets.only(left: DetailDoc1X, top: DetailDoc2Y),
                    child: Text(
                      product.discountPrice != null
                          ? '${numberFormat.format(product.discountPrice!)}원'
                          : '',
                      style: TextStyle(
                        fontSize: DetailDocTextFontSize4,
                        color: BLACK_COLOR, // 텍스트 색상
                        fontFamily: 'NanumGothic',
                        fontWeight: FontWeight.w800, // ExtraBold로 설정,
                      ),
                    ),
                  ),
                SizedBox(height: interval1Y),
                // 제품 색상 옵션을 표시함.
                Row(
                  children: product.colors!
                      .asMap()
                      .map((index, color) => MapEntry(
                            index,
                            Padding(
                              padding: EdgeInsets.only(
                                left: index == 0 ? DetailDoc1X : DetailDoc2X,
                                // 첫 번째 이미지만 left: 14.0, 나머지는 right: 2.0
                                right: DetailDoc2X,
                              ),
                              // 썸네일이 있으면 이미지를 표시하고, 없으면 아이콘을 표시
                              child: color != null && color!.isNotEmpty
                                  ? Image.network(
                                      color,
                                      width: DetailDocColorImageWidth,
                                      height: DetailDocColorImageHeight,
                                      // 이미지 로드 실패 시 아이콘 표시
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons.image_not_supported,
                                        color: GRAY88_COLOR,
                                        size: DetailDocColorImageWidth,
                                      ),
                                    )
                                  : Icon(
                                      Icons.image_not_supported,
                                      color: GRAY88_COLOR,
                                      size: DetailDocColorImageWidth,
                                    ), // 썸네일이 없을 때 아이콘을 표시
                            ),
                          ))
                      .values
                      .toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} // -------- ProductInfoDetailScreenNavigation 클래스 내용 구현 끝

// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 시작
// ------ buildProdDetailScreenContents 위젯 시작: 상품 상세 정보를 구성하는 위젯을 정의.
Widget buildProdDetailScreenContents(BuildContext context, WidgetRef ref,
    ProductContent product, PageController pageController) {
  // print('buildProductDetails 호출');
  // print('상품 소개: ${product.briefIntroduction}');
  return SingleChildScrollView(
    // 스크롤이 가능하도록 SingleChildScrollView 위젯을 사용.
    child: Column(
      // 세로 방향으로 위젯들을 나열하는 Column 위젯을 사용.
      crossAxisAlignment: CrossAxisAlignment.start,
      // 자식 위젯들을 왼쪽 정렬로 배치.
      children: [
        Container(
          // decoration: BoxDecoration(
          //   border: Border(
          //     top: BorderSide(color: BLACK_COLOR, width: 1.0), // 상단 테두리 색상을 지정함
          //   ),
          // ),
          child: CommonCardView(
            content: buildProductImageSliderSection(
                context, product, ref, pageController, product.docId),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            // 그림자 효과 0
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            // 좌우 여백을 0으로 설정.
            padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 0.0으로 설정.
          ),
        ), // 이미지 슬라이더 섹션
        // 제품 소개 부분과 가격 부분을 표시하는 위젯을 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: BLACK_COLOR, width: 1.0),
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content: buildProductBriefIntroAndPriceInfoSection(
                context, ref, product),
            // 제품 소개 및 가격 정보 부분 섹션
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            // 그림자 효과 0
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            // 좌우 여백을 0으로 설정.
            padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 0.0으로 설정.
          ),
        ),
        // 제품 색상과 사이즈 부분을 표시하는 클래스를 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content: ProductColorAndSizeSelection(product: product),
            // 색상과 사이즈 선택 관련 섹션
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0.0,
            // 그림자 효과 0
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            // 좌우 여백을 0으로 설정.
            padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 1.0으로 설정.
          ),
        ),
        // 제품 선택한 색상과 사이즈 부분을 표시하는 위젯을 호출.
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom:
                  BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 지정함
            ),
          ),
          child: CommonCardView(
            content:
                buildProductAllCountAndPriceSelection(context, ref, product),
            // 총 선택 내용이 나오는 섹션
            backgroundColor: ORANGE_BEIGE_COLOR,
            elevation: 0.0,
            margin: const EdgeInsets.symmetric(horizontal: 0.0),
            padding: const EdgeInsets.all(0.0),
          ),
        ),
      ],
    ),
  );
}
// ------ buildProdDetailScreenContents 위젯의 구현 끝

// ------ buildProductImageSlider 위젯 시작: 제품 이미지 부분을 구현.
Widget buildProductImageSliderSection(
    BuildContext context,
    ProductContent product,
    WidgetRef ref,
    PageController pageController,
    String productId) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393 세로 852
  final double referenceWidht = 393.0;
  final double referenceHeight = 852.0;

  // 이미지 부분 수치
  final double ImageSliderSectionHeight =
      screenSize.height * (421 / referenceHeight);

  // 이미지 인디케이터 부분 수치
  final double ImageSliderSectionIndicator1Y =
      screenSize.height * (10 / referenceHeight);
  final double ImageSliderSectionIndicator2Y =
      screenSize.height * (8 / referenceHeight);
  final double ImageSliderSectionIndicator1X =
      screenSize.width * (4 / referenceWidht);
  final double ImageSliderSectionIndicatorWidth =
      screenSize.height * (12 / referenceHeight);
  final double ImageSliderSectionIndicatorHeight =
      screenSize.height * (12 / referenceHeight);

  final double interval1X = screenSize.width * (250 / referenceWidht);

  // productId를 사용하여 pageProvider를 가져옴.
  final pageProvider = getImagePageProvider(productId);

  return Stack(
    children: [
      // CarouselSlider 위젯을 사용하여 이미지를 슬라이드 형태로 보여줌.
      CarouselSlider(
        options: CarouselOptions(
          height: ImageSliderSectionHeight,
          viewportFraction: 1.0,
          // 페이지가 변경될 때 호출되는 함수.
          onPageChanged: (index, reason) {
            // pageProvider의 상태를 변경.
            ref.read(pageProvider.notifier).state = index;
          },
        ),
        // product.detailPageImages를 반복하여 이미지 위젯을 생성.
        items: product.detailPageImages?.map((image) {
          // product.detailPageImages 리스트를 map 함수로 반복
          return Builder(
            builder: (BuildContext context) {
              // 각 항목에 대한 빌더 함수 정의
              return GestureDetector(
                // 터치 제스처를 감지하는 위젯
                onTap: () {
                  // 터치 시 동작할 함수 정의
                  Navigator.push(
                    // 새로운 화면으로 이동
                    context,
                    MaterialPageRoute(
                      // 페이지 라우트 정의
                      builder: (_) => ProductDetailOriginalImageScreen(
                        // ProductDetailOriginalImageScreen 화면으로 이동
                        images: product.detailPageImages!, // 이미지 리스트 전달
                        initialPage: ref.read(pageProvider), // 초기 페이지 인덱스 전달
                      ),
                    ),
                  );
                },
                // 이미지가 있으면 이미지를 표시하고, 없으면 아이콘을 표시
                child: image != null && image!.isNotEmpty
                    ? Image.network(
                        // 네트워크 이미지를 보여주는 위젯
                        image, // 이미지 URL 설정
                        fit: BoxFit.cover, // 이미지가 컨테이너를 가득 채우도록 설정
                        width:
                            MediaQuery.of(context).size.width, // 화면의 너비에 맞게 설정
                        // 이미지 로드 실패 시 아이콘 표시
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported,
                          color: GRAY88_COLOR,
                          size: interval1X,
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: GRAY88_COLOR,
                        size: interval1X,
                      ), // 썸네일이 없을 때 아이콘을 표시
              );
            },
          );
        }).toList(), // 리스트로 변환
      ),
      // 페이지 인디케이터를 Row 위젯으로 생성.
      Positioned(
        bottom: ImageSliderSectionIndicator1Y, // 이미지 하단에서 10픽셀 위에 인디케이터를 배치
        left: 0,
        right: 0, // 양쪽 모두 0으로 설정해 인디케이터를 중앙 정렬
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // product.detailPageImages의 각 항목을 반복하여 인디케이터를 생성함.
          children: product.detailPageImages?.asMap().entries.map((entry) {
                return GestureDetector(
                  // 인디케이터를 클릭하면 해당 페이지로 이동함.
                  onTap: () => pageController.jumpToPage(entry.key),
                  child: Container(
                    width: ImageSliderSectionIndicatorWidth,
                    height: ImageSliderSectionIndicatorHeight,
                    margin: EdgeInsets.symmetric(
                        vertical: ImageSliderSectionIndicator2Y,
                        horizontal: ImageSliderSectionIndicator1X),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // 현재 페이지를 기준으로 인디케이터 색상을 변경함.
                      color: ref.watch(pageProvider) == entry.key
                          ? BLACK_COLOR
                          : WHITE_COLOR,
                    ),
                  ),
                );
              }).toList() ??
              [],
        ),
      ),
    ],
  );
}
// ------ buildProductImageSlider 위젯 끝: 제품 이미지 부분을 구현.

// ------ buildProductBriefIntroAndPriceInfoSection 위젯 시작: 제품 소개 및 가격 정보 부분을 구현.
Widget buildProductBriefIntroAndPriceInfoSection(
    BuildContext context, WidgetRef ref, ProductContent product) {
  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 섹션 내 x, y 부분 수치
  final double sectionX = screenSize.width * (24 / referenceWidth);
  final double section1Y = screenSize.width * (30 / referenceHeight);
  final double section2Y = screenSize.width * (10 / referenceHeight);
  final double section3Y = screenSize.width * (1 / referenceHeight);
  final double width1X = screenSize.width * (15 / referenceWidth);

  // 상품번호 텍스트 부분 수치
  final double productNumberFontSize =
      screenSize.height * (13 / referenceHeight); // 텍스트 크기
  // 상품 설명 텍스트 부분 수치
  final double productIntroductionFontSize =
      screenSize.height * (20 / referenceHeight); // 텍스트 크기
  // 상품 원가 텍스트 부분 수치
  final double productOriginalPriceFontSize =
      screenSize.height * (16 / referenceHeight); // 텍스트 크기
  // 상품 할인가 텍스트 부분 수치
  final double productDiscountPriceFontSize =
      screenSize.height * (20 / referenceHeight); // 텍스트 크기
  // 상품 할인율 텍스트 부분 수치
  final double productDiscountPercentFontSize =
      screenSize.height * (18 / referenceHeight); // 텍스트 크기

  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'); // 정규식을 사용하여 천 단위로 쉼표를 추가.
  return Padding(
    padding: EdgeInsets.only(left: sectionX, right: sectionX),
    // 좌/우 패딩을 sectionX로 설정
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 자식 위젯들을 왼쪽 정렬
      children: [
        // 제품 번호를 표시함.
        if (product.productNumber != null) // productNumber가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section1Y), // 상단 패딩을 section1Y로 설정
            child: Text(
              '상품번호: ${product.productNumber ?? ''}', // productNumber 내용을 표시
              style: TextStyle(
                fontSize: productNumberFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                color: BLACK_COLOR,
              ), // 글자 크기를 14로 설정
            ),
          ),
        // 제품 간단한 소개를 표시함.
        if (product.briefIntroduction !=
            null) // briefIntroduction이 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section2Y), // 상단 패딩을 section2Y로 설정
            child: Text(
              product.briefIntroduction!, // briefIntroduction 내용을 표시
              style: TextStyle(
                fontSize: productIntroductionFontSize,
                fontWeight: FontWeight.bold,
                fontFamily: 'NanumGothic',
                color: BLACK_COLOR,
              ),
              maxLines: 2, // 최대 2줄로 표시
              overflow: TextOverflow.visible, // 넘치는 텍스트를 표시
            ),
          ),
        // 원래 가격을 표시함. 소수점은 표시하지 않음.
        if (product.originalPrice != null) // originalPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section1Y), // 상단 패딩을 section1Y로 설정
            child: Text(
              '${product.originalPrice != null ? product.originalPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},') : ''}원', // 원래 가격을 표시, 소수점 없음
              style: TextStyle(
                fontSize: productOriginalPriceFontSize,
                decoration: TextDecoration.lineThrough,
                // 취소선을 추가
                color: GRAY60_COLOR,
                // 색상을 연한 회색으로 설정
                decorationColor: GRAY38_COLOR,
                // 취소선 색상을 진한 회색으로 설정
                fontFamily: 'NanumGothic',
              ),
            ),
          ),
        // 할인된 가격을 표시함. 소수점은 표시하지 않음.
        if (product.discountPrice != null) // discountPrice가 null이 아닌 경우에만 표시
          Padding(
            padding: EdgeInsets.only(top: section3Y), // 상단 패딩을 section2Y로 설정
            child: Row(
              children: [
                Text(
                  '${product.discountPrice != null ? product.discountPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},') : ''}원',
                  // 할인된 가격을 표시, 소수점 없음
                  style: TextStyle(
                    fontSize: productDiscountPriceFontSize,
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR,
                    fontFamily: 'NanumGothic',
                  ),
                ),
                SizedBox(width: width1X), // 간격을 추가
                // 할인율을 빨간색으로 표시함.
                if (product.discountPercent !=
                    null) // discountPercent가 null이 아닌 경우에만 표시
                  Text(
                    '${product.discountPercent != null ? product.discountPercent!.toStringAsFixed(0) : ''}%',
                    // 할인율을 표시, 소수점 없음
                    // 할인율을 표시, 소수점 없음
                    style: TextStyle(
                      fontSize: productDiscountPercentFontSize,
                      fontWeight: FontWeight.w800,
                      color: RED46_COLOR,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                Spacer(), // 할인율과의 간격 공간 생성
                // 찜 목록 아이콘 동작 로직 관련 클래스인 WishlistIconButton 재사용하여 구현
                WishlistIconButton(
                  product: product, // 'product' 파라미터를 전달
                ),
              ],
            ),
          ),
        SizedBox(height: section1Y),
      ],
    ),
  );
}
// ------ buildProductBriefIntroAndPriceInfoSection 위젯의 구현 끝: 제품 소개 및 가격 정보 부분을 구현.

// ------ buildColorAndSizeSelection 클래스 시작: 색상 및 사이즈 선택 부분을 구현.
class ProductColorAndSizeSelection extends ConsumerStatefulWidget {
  final ProductContent product;

  const ProductColorAndSizeSelection({Key? key, required this.product})
      : super(key: key);

  @override
  _ProductColorAndSizeSelectionState createState() =>
      _ProductColorAndSizeSelectionState();
}

class _ProductColorAndSizeSelectionState
    extends ConsumerState<ProductColorAndSizeSelection> {
  @override
  void initState() {
    super.initState();

    // 초기값 설정을 위해 첫 번째 옵션을 가져옴
    final initialColorImage = widget.product.colorOptions?.isNotEmpty ?? false
        ? widget.product.colorOptions!.first['url']
        : null;
    final initialColorText = widget.product.colorOptions?.isNotEmpty ?? false
        ? widget.product.colorOptions!.first['text']
        : null;
    final initialSize = widget.product.sizes?.isNotEmpty ?? false
        ? widget.product.sizes!.first
        : null;

    // 초기값으로 상태를 업데이트
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(colorSelectionUrlProvider.notifier).state ??=
          initialColorImage; // 선택된 색상 이미지
      ref.read(colorSelectionTextProvider.notifier).state ??=
          initialColorText; // 선택된 색상 텍스트
      ref.read(sizeSelectionIndexProvider.notifier).state ??=
          initialSize; // 선택된 사이즈
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 섹션 내 x, y 부분 수치
    final double sectionX = screenSize.width * (24 / referenceWidth);
    final double section1Y = screenSize.width * (40 / referenceHeight);
    final double section2Y = screenSize.width * (8 / referenceHeight);
    final double width1X = screenSize.width * (57 / referenceWidth);
    final double width2X = screenSize.width * (12 / referenceWidth);
    final double width3X = screenSize.width * (45 / referenceWidth);

    // 색상 텍스트 부분 수치
    final double colorFontSize = screenSize.height * (14 / referenceHeight);
    // 색상 이미지 데이터 부분 수치
    final double colorImageLength = screenSize.height * (16 / referenceHeight);
    // 색상 텍스트 데이터 부분 수치
    final double colorTextSize = screenSize.height * (14 / referenceHeight);
    // 사이즈 텍스트 부분 수치
    final double sizeFontSize = screenSize.height * (14 / referenceHeight);
    // 사이즈 텍스트 데이터 부분 수치
    final double sizeTextSize = screenSize.height * (14 / referenceHeight);

    return Padding(
      padding: EdgeInsets.only(
          left: sectionX, right: sectionX, top: section1Y, bottom: section1Y),
      // 좌우 여백을 sectionX, 위쪽 여백을 section1Y로 설정.
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('색상',
                  style: TextStyle(
                    fontSize: colorFontSize,
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR,
                    fontFamily: 'NanumGothic',
                  )), // '색상' 라벨을 표시.
              SizedBox(width: width1X), // '색상' 라벨과 드롭다운 버튼 사이의 간격을 width1X로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  underline: SizedBox.shrink(),
                  // 아래 선을 보이지 않게 설정.
                  value: product.colorOptions?.any((option) =>
                              option['url'] ==
                              ref.watch(colorSelectionUrlProvider)) ==
                          true
                      ? ref.watch(colorSelectionUrlProvider)
                      : null,
                  // 선택된 색상 값을 가져옴.
                  onChanged: (newValue) {
                    final selectedIndex = product.colorOptions?.indexWhere(
                            (option) => option['url'] == newValue) ??
                        -1;
                    final selectedText = product.colorOptions?.firstWhere(
                        (option) => option['url'] == newValue)?['text'];
                    // 새로운 값과 일치하는 색상 옵션의 인덱스를 찾음.
                    ref.read(colorSelectionIndexProvider.notifier).state =
                        selectedIndex;
                    ref.read(colorSelectionTextProvider.notifier).state =
                        selectedText ?? ''; // 색상 텍스트 업데이트
                    // 색상 인덱스를 업데이트.
                    ref.read(colorSelectionUrlProvider.notifier).state =
                        newValue;
                    // 선택된 색상 URL을 업데이트.
                  },
                  items: product.colorOptions
                          ?.map((option) => DropdownMenuItem<String>(
                                value: option['url'], // 각 옵션의 URL을 값으로 사용.
                                child: Row(
                                  children: [
                                    option['url'] != null && option['url'] != ''
                                        ? Image.network(
                                            option['url'],
                                            width: colorImageLength,
                                            height:
                                                colorImageLength, // URL이 있는 경우 이미지를 표시
                                            // URL 이미지 로드 실패 시 아이콘 표시
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.image_not_supported,
                                              color: GRAY88_COLOR,
                                              size: colorImageLength,
                                            ),
                                          )
                                        : Icon(
                                            Icons.image_not_supported,
                                            color: GRAY88_COLOR,
                                            size:
                                                colorImageLength, // 이미지 크기에 맞춘 아이콘 크기 설정
                                          ), // URL이 없을 경우 아이콘을 표시
                                    SizedBox(width: width2X),
                                    // 이미지와 텍스트 사이의 간격을 width2X로 설정.
                                    Text(
                                      option['text'] ?? '',
                                      // 색상의 텍스트 설명을 표시, 값이 없을 경우 빈 문자열.
                                      style: TextStyle(
                                        fontSize: colorTextSize,
                                        fontWeight: FontWeight.bold,
                                        color: BLACK_COLOR,
                                        fontFamily: 'NanumGothic',
                                      ),
                                    ), // 색상의 텍스트 설명을 표시.
                                  ],
                                ),
                              ))
                          .toList() ??
                      [], // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
            ],
          ),
          SizedBox(height: section2Y),
          // 색상 선택과 사이즈 선택 사이의 수직 간격을 section2Y로 설정.
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            // 자식 위젯들을 왼쪽 정렬로 배치.
            children: [
              Text('사이즈',
                  style: TextStyle(
                    fontSize: sizeFontSize,
                    fontWeight: FontWeight.bold,
                    color: BLACK_COLOR,
                    fontFamily: 'NanumGothic',
                  )),
              // '사이즈' 라벨을 표시.
              SizedBox(width: width3X),
              // '사이즈' 라벨과 드롭다운 버튼 사이의 간격을 width3X로 설정.
              Expanded(
                // 드롭다운 버튼을 화면 너비에 맞게 확장.
                child: DropdownButton<String>(
                  isExpanded: true,
                  // 드롭다운 버튼의 너비를 최대로 확장.
                  underline: SizedBox.shrink(),
                  // 아래 선을 보이지 않게 설정.
                  value: product.sizes?.contains(
                              ref.watch(sizeSelectionIndexProvider)) ==
                          true
                      ? ref.watch(sizeSelectionIndexProvider)
                      : null,
                  // 선택된 사이즈 값을 가져옴.
                  onChanged: (newValue) {
                    ref.read(sizeSelectionIndexProvider.notifier).state =
                        newValue!;
                    // 새로운 사이즈가 선택되면 상태를 업데이트.
                  },
                  items: product.sizes
                          ?.map((size) => DropdownMenuItem<String>(
                                value: size, // 각 사이즈를 값으로 사용.
                                child: Text(size,
                                    style: TextStyle(
                                      fontSize: sizeTextSize,
                                      fontWeight: FontWeight.bold,
                                      color: BLACK_COLOR,
                                      fontFamily: 'NanumGothic',
                                    )), // 사이즈 텍스트를 표시.
                              ))
                          .toList() ??
                      [], // 드롭다운 메뉴 아이템 목록을 생성.
                ),
              ),
              SizedBox(height: section1Y)
            ],
          ),
        ],
      ),
    );
  }
}
// ------ buildColorAndSizeSelection 클래스 끝: 색상 및 사이즈 선택 부분을 구현.

// ------ buildProductAllCountAndPriceSelection 위젯 시작: 선택한 색상, 선택한 사이즈, 수량 및 총 가격 부분을 구현.
// 선택한 색상, 사이즈, 수량, 총 가격을 표시하는 위젯을 생성하는 함수.
Widget buildProductAllCountAndPriceSelection(
    BuildContext context, WidgetRef ref, ProductContent product) {
  // 선택한 색상 URL을 가져옴.
  final selectedColorUrl = ref.watch(colorSelectionUrlProvider);
  // 선택한 색상 텍스트를 가져옴.
  final selectedColorText = ref.watch(colorSelectionTextProvider);
  // 선택한 사이즈를 가져옴.
  final selectedSize = ref.watch(sizeSelectionIndexProvider);
  // 선택한 수량을 가져옴.
  final quantity = ref.watch(detailQuantityIndexProvider);

  // 할인된 가격을 가져오고, 없으면 0을 설정.
  double discountPrice = product.discountPrice ?? 0;
  // 총 가격을 계산.
  double totalPrice =
      (discountPrice * quantity).isNaN ? 0 : discountPrice * quantity;
  // 상품 최대 수량
  final maxStockQuantity = 10001;

  // 정규식을 사용하여 천 단위로 쉼표를 추가.
  final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  // 숫자 형식을 지정하기 위한 NumberFormat 객체 생성
  final numberFormat = NumberFormat('###,###');

  // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
  final Size screenSize = MediaQuery.of(context).size;

  // 기준 화면 크기: 가로 393, 세로 852
  final double referenceWidth = 393.0;
  final double referenceHeight = 852.0;

  // 섹션 내 x, y 부분 수치
  final double sectionX = screenSize.width * (20 / referenceWidth);
  final double section1Y = screenSize.height * (15 / referenceHeight);
  final double section2Y = screenSize.height * (10 / referenceHeight);
  final double width1X = screenSize.width * (57 / referenceWidth);
  final double width2X = screenSize.width * (12 / referenceWidth);
  final double width3X = screenSize.width * (41 / referenceWidth);
  final double width4X = screenSize.width * (30 / referenceWidth);
  final double width5X = screenSize.width * (60 / referenceWidth);
  final double width6X = screenSize.width * (15 / referenceWidth);
  final double width7X = screenSize.width * (70 / referenceWidth);

  // 선택한 색상 텍스트 부분 수치
  final double selectedColorFontSize =
      screenSize.height * (14 / referenceHeight);
  // 선택한 색상 이미지 데이터 부분 수치
  final double selectedColorImageLength =
      screenSize.height * (16 / referenceHeight);
  // 산텍힌 색상 텍스트 데이터 부분 수치
  final double selectedColorTextSize =
      screenSize.height * (14 / referenceHeight);
  // 선택한 사이즈 텍스트 부분 수치
  final double selectedSizeFontSize =
      screenSize.height * (14 / referenceHeight);
  // 선택한 사이즈 텍스트 데이터 부분 수치
  final double selectedSizeTextSize =
      screenSize.height * (14 / referenceHeight);
  // 선택한 수량 텍스트 데이터 부분 수치
  final double selectedCountTextSize =
      screenSize.height * (14 / referenceHeight);
  // 총 가격 텍스트 데이터 부분 수치
  final double selectedAllPriceTextSize =
      screenSize.height * (18 / referenceHeight);

  // 직접입력 버튼 수치
  final double directInsertBtnWidth = screenSize.width * (90 / referenceWidth);
  final double directInsertBtnHeight =
      screenSize.height * (30 / referenceHeight);
  final double directInsertBtnFontSize =
      screenSize.height * (10 / referenceHeight);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 색상과 사이즈가 선택되었을 때만 보여줌.
      if (selectedColorUrl != null && selectedSize != null)
        Padding(
          padding:
              EdgeInsets.only(left: sectionX, right: sectionX, top: section1Y),
          // 좌우 여백을 sectionX, 위쪽 여백을 section1Y로 설정.
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 선택한 색상을 텍스트로 표시함.
                  Text('선택한 색상 :',
                      style: TextStyle(
                        fontSize: selectedColorFontSize,
                        fontWeight: FontWeight.bold,
                        color: BLACK_COLOR,
                        fontFamily: 'NanumGothic',
                      )),
                  SizedBox(width: width1X), // 텍스트와 이미지 사이의 간격을 width1X로 설정.
                  // 선택한 색상이 존재하면 이미지를 표시함.
                  selectedColorUrl != null && selectedColorUrl != ''
                      ? Image.network(
                          selectedColorUrl,
                          width: selectedColorImageLength,
                          height: selectedColorImageLength,
                          // URL 이미지 로드 실패 시 아이콘 표시
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            color: GRAY88_COLOR,
                            size: selectedColorImageLength,
                          ),
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: GRAY88_COLOR,
                          size:
                              selectedColorImageLength, // 이미지 크기에 맞춘 아이콘 크기 설정
                        ),
                  SizedBox(width: width2X), // 이미지와 텍스트 사이의 간격을 width2X로 설정.
                  // 선택한 색상 이름을 텍스트로 표시함.
                  Text(
                    selectedColorText ?? '',
                    style: TextStyle(
                      fontSize: selectedColorTextSize,
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                ],
              ),
              SizedBox(height: section2Y), // 색상과 사이즈 사이의 수직 간격을 section2Y로 설정.
              Row(
                children: [
                  // 선택한 사이즈를 텍스트로 표시함.
                  Text(
                    '선택한 사이즈 : ',
                    style: TextStyle(
                      fontSize: selectedSizeFontSize,
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                  SizedBox(width: width3X), // 텍스트와 이미지 사이의 간격을 width3X로 설정.
                  // 선택한 색상 이름을 텍스트로 표시함.
                  Text(
                    selectedSize ?? '',
                    style: TextStyle(
                      fontSize: selectedSizeTextSize,
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      SizedBox(height: section2Y), // 색상과 사이즈 사이의 수직 간격을 section2Y로 설정.
      Padding(
        padding: EdgeInsets.symmetric(horizontal: sectionX),
        // 좌우 여백 20, 수직 여백 8로 설정.
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // 자식 위젯들을 좌우로 배치.
          children: [
            // '수량' 텍스트를 표시함.
            Text(
              '수량 : ',
              style: TextStyle(
                fontSize: selectedCountTextSize,
                fontWeight: FontWeight.bold,
                color: BLACK_COLOR,
                fontFamily: 'NanumGothic',
              ),
            ),
            SizedBox(width: width4X),
            Row(
              children: [
                // 수량 감소 버튼. 수량이 1보다 클 때만 작동함.
                IconButton(
                  icon: Icon(Icons.remove, size: section1Y),
                  onPressed: quantity > 1
                      ? () {
                          ref
                              .read(detailQuantityIndexProvider.notifier)
                              .state--;
                        }
                      : null,
                ),
                // 현재 수량을 표시하는 컨테이너.
                Container(
                  width: width7X,
                  alignment: Alignment.center,
                  child: Text(
                    quantity != null
                        ? quantity!
                            .toStringAsFixed(0)
                            .replaceAllMapped(reg, (match) => '${match[1]},')
                        : '',
                    style: TextStyle(
                      fontSize: selectedCountTextSize,
                      fontWeight: FontWeight.bold,
                      color: BLACK_COLOR,
                      fontFamily: 'NanumGothic',
                    ),
                  ),
                ),
                // 수량 증가 버튼.
                IconButton(
                  icon: Icon(Icons.add, size: section1Y),
                  onPressed: () {
                    if (quantity < maxStockQuantity - 1) {
                      ref.read(detailQuantityIndexProvider.notifier).state++;
                    } else {
                      showCustomSnackBar(context,
                          '최대 수량을 초과했습니다. 최대 수량: ${numberFormat.format(maxStockQuantity - 1)}개');
                    }
                  },
                ),
                SizedBox(width: width6X),
                // 수량을 직접 입력할 수 있는 버튼.
                Container(
                  width: directInsertBtnWidth,
                  height: directInsertBtnHeight,
                  child: ElevatedButton(
                    onPressed: () async {
                      final TextEditingController controller =
                          TextEditingController();
                      String input = '';

                      // showSubmitAlertDialog 함수를 사용해 수량 입력 알림창 생성
                      await showSubmitAlertDialog(
                        context,
                        title: '[수량 입력]', // 알림창 제목
                        contentWidget: Material(
                          // Material 위젯을 추가해 TextField를 감쌈
                          color: Colors.transparent,
                          // 배경색을 투명으로 설정하여 알림창 배경과 동일하게 만듦
                          child: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            // 숫자 입력 전용 키보드 표시
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                              // 숫자만 입력되도록 필터링
                            ],
                            autofocus: true,
                            cursorColor: ORANGE56_COLOR, // 커서 색상 설정
                            // 자동 포커스 설정
                            onChanged: (value) {
                              input = value; // 입력된 값 저장
                            },
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: BLACK_COLOR), // 포커스 시 검은색 테두리 표시
                              ),
                            ),
                          ),
                        ),
                        actions: buildAlertActions(
                          context,
                          noText: '취소',
                          // '취소' 버튼 텍스트
                          yesText: '확인',
                          // '확인' 버튼 텍스트
                          noTextStyle: TextStyle(
                            fontFamily: 'NanumGothic',
                            color: BLACK_COLOR, // '취소' 텍스트 색상
                          ),
                          yesTextStyle: TextStyle(
                            fontFamily: 'NanumGothic',
                            color: RED46_COLOR, // '확인' 텍스트 색상
                            fontWeight: FontWeight.bold, // 텍스트 굵게
                          ),
                          onYesPressed: () {
                            if (input.isNotEmpty) {
                              int enteredQuantity = int.parse(input);
                              if (enteredQuantity > 0 &&
                                  enteredQuantity < maxStockQuantity) {
                                ref
                                    .read(detailQuantityIndexProvider.notifier)
                                    .state = int.parse(input);
                              } else if (enteredQuantity < 1) {
                                // 0 이하의 값을 입력한 경우, 안내 메시지를 표시하거나 수량 업데이트를 하지 않음
                                print('1개 이상의 수량을 입력해주세요.');
                                showCustomSnackBar(
                                    context, '1개 이상의 수량을 입력해주세요.');
                              } else {
                                showCustomSnackBar(context,
                                    '최대 수량을 초과했습니다. 최대 수량: ${numberFormat.format(maxStockQuantity - 1)}개');
                              }
                              Navigator.of(context).pop();
                              // 다이얼로그 닫기.
                            }
                            ;
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: ORANGE_BEIGE_COLOR,
                      backgroundColor: ORANGE_BEIGE_COLOR,
                      side: BorderSide(
                        color: GRAY65_COLOR,
                      ), // 버튼 테두리 색상 설정
                    ),
                    child: Text(
                      '직접입력',
                      style: TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: directInsertBtnFontSize,
                        fontWeight: FontWeight.bold,
                        color: GRAY40_COLOR,
                      ),
                    ), // 색상 수정
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // 총 가격을 표시.
      Padding(
        padding:
            EdgeInsets.symmetric(horizontal: sectionX, vertical: section2Y),
        child: Text(
          '총 가격 :    ${totalPrice != null ? totalPrice!.toStringAsFixed(0).replaceAllMapped(reg, (match) => '${match[1]},') : ''}원',
          style: TextStyle(
            fontFamily: 'NanumGothic',
            fontSize: selectedAllPriceTextSize,
            fontWeight: FontWeight.bold,
            color: BLACK_COLOR,
          ),
        ),
      ),
    ],
  );
}
// ------ buildProductAllCountAndPriceSelection 위젯 끝: 선택한 색상, 선택한 사이즈, 수량 및 총 가격 부분을 구현.
// ------ 상품 상세 화면 내 UI 관련 위젯 공통 코드 내용 끝

// ------ 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스 구현 부분 시작
class ProductDetailScreenTabs extends ConsumerWidget {
  final Widget productInfoContent; // '상품 정보' 탭의 내용을 담는 위젯
  final List<ProductReviewContents> reviewsContent; // '리뷰' 탭의 내용을 담는 리스트
  final Widget inquiryContent; // '문의' 탭의 내용을 담는 위젯

  // 생성자, 각 탭의 내용을 받음.
  ProductDetailScreenTabs({
    required this.productInfoContent,
    required this.reviewsContent,
    required this.inquiryContent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 선택된 탭 섹션을 가져옴.
    final currentTabSection = ref.watch(prodDetailScreenTabSectionProvider);

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 섹션 내 y 부분 수치
    final double section1Y = screenSize.height * (20 / referenceHeight);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: section1Y),
        _buildTabButtons(context, ref, currentTabSection), // 탭 버튼들을 빌드
        SizedBox(height: section1Y), // 탭과 컨텐츠 사이에 간격을 추가
        _buildSectionContent(context, currentTabSection), // 현재 선택된 탭의 내용을 빌드
      ],
    );
  }

  // 탭 버튼들을 빌드하는 위젯인 _buildTabButtons
  Widget _buildTabButtons(BuildContext context, WidgetRef ref,
      ProdDetailScreenTabSection currentTabSection) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // '상품정보' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.productInfo,
            currentTabSection, '상품정보'),
        // '리뷰' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.reviews,
            currentTabSection, '리뷰'),
        // '문의' 탭 버튼을 빌드
        _buildTabButton(context, ref, ProdDetailScreenTabSection.inquiry,
            currentTabSection, '문의'),
      ],
    );
  }

  // 개별 탭 버튼을 빌드하는 위젯인 _buildTabButton
  Widget _buildTabButton(
      BuildContext context,
      WidgetRef ref,
      ProdDetailScreenTabSection section,
      ProdDetailScreenTabSection currentTabSection,
      String text) {
    final isSelected = section == currentTabSection; // 현재 선택된 탭인지 확인

    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 세로 852
    final double referenceHeight = 852.0;

    // 상품정보, 리뷰 정보, 문의 선택 버튼 부분 수치
    final double _buildTabButtonFontSize =
        screenSize.height * (14 / referenceHeight);

    return GestureDetector(
      onTap: () {
        // 탭 버튼 클릭 시 선택된 탭 섹션을 변경
        ref.read(prodDetailScreenTabSectionProvider.notifier).state = section;
      },
      child: Column(
        children: [
          // 탭 버튼 텍스트
          Text(
            text,
            style: TextStyle(
              fontSize: _buildTabButtonFontSize,
              fontFamily: 'NanumGothic',
              color: isSelected ? BLACK_COLOR : GRAY62_COLOR,
              // 선택된 탭이면 검정색, 아니면 회색
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.normal, // 선택된 탭이면 굵게, 아니면 일반
            ),
          ),
          if (isSelected) // 선택된 탭이면 밑줄 표시
            Container(
              width: _buildTabButtonFontSize * 4.5,
              height: 2,
              color: BLACK_COLOR, // 밑줄 색상 검정
            ),
        ],
      ),
    );
  }

  // 선택된 탭 섹션의 내용을 빌드하는 위젯인 _buildSectionContent
  Widget _buildSectionContent(
      BuildContext context, ProdDetailScreenTabSection section) {
    switch (section) {
      case ProdDetailScreenTabSection.productInfo: // '상품정보' 섹션이면
        return productInfoContent; // '상품정보' 내용을 반환
      case ProdDetailScreenTabSection.reviews: // '리뷰' 섹션이면
        if (reviewsContent.isEmpty) {
          return Center(
              child: Text('현재 해당 상품 관련 리뷰가 없습니다.')); // 리뷰 데이터가 없을 때 표시
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionTitle(context, 'REVIEW INFO'),
              ...reviewsContent, // '리뷰' 내용을 반환
            ],
          );
        }
      case ProdDetailScreenTabSection.inquiry: // '문의' 섹션이면
        return ProductInquiryContents(); // '문의' 내용을 반환
      default:
        return Container(); // 기본적으로 빈 컨테이너 반환
    }
  }
}
// ------ 상품 상세 화면에서 '상품 정보', '리뷰', '문의' 탭으로 각 탭이 선택될 때마다 각 내용이 나오도록 하는 ProductDetailScreenTabs 클래스 구현 부분 끝

// -------- 상품 상세 화면 내 상품정보에서 UI로 구현되는 내용 관련 ProductInfoContents 클래스 부분 시작
class ProductInfoContents extends ConsumerStatefulWidget {
  final String fullPath;

  const ProductInfoContents({Key? key, required this.fullPath})
      : super(key: key);

  @override
  _ProductInfoContentsState createState() => _ProductInfoContentsState();
}

class _ProductInfoContentsState extends ConsumerState<ProductInfoContents> {
  // `showFullImage` 상태는 Provider로 관리하므로 별도의 상태 변수가 필요하지 않음.

  // 이미지 URL을 받아서 이미지의 1/5만 표시하는 위젯을 생성하는 함수
  // 이미지의 상단 부분만 보여줌.
  Widget buildPartialImage(BuildContext context, String imageUrl) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double interval3X = screenSize.width * (150 / referenceWidth);

    return LayoutBuilder(
      builder: (context, constraints) {
        return ClipRect(
          child: Align(
            alignment: Alignment.topCenter, // 이미지의 상단을 기준으로 정렬함.
            heightFactor: 0.2, // 이미지 높이를 1/5만큼 설정함.
            child: imageUrl != null && imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl, // 주어진 URL의 이미지를 네트워크에서 불러옴.
                    fit: BoxFit.fitWidth, // 이미지가 화면 너비에 맞춰 조정됨.
                    width:
                        MediaQuery.of(context).size.width, // 화면의 너비만큼 이미지를 조정함.
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.image_not_supported,
                      color: GRAY88_COLOR,
                      size: interval3X,
                    ), // 이미지 로드 실패 시 아이콘 표시
                  )
                : Icon(
                    Icons.image_not_supported,
                    color: GRAY88_COLOR,
                    size: interval3X,
                  ), // 이미지 URL이 없을 때 아이콘 표시
          ),
        );
      },
    );
  }

  // 전체 이미지를 표시하는 함수
  // 이미지 전체를 보여줌.
  Widget buildFullImage(BuildContext context, String imageUrl) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    final double interval3X = screenSize.width * (150 / referenceWidth);

    return imageUrl != null && imageUrl.isNotEmpty
        ? Image.network(
            imageUrl, // 주어진 URL의 이미지를 네트워크에서 불러옴.
            fit: BoxFit.fitWidth, // 이미지가 화면 너비에 맞춰 조정됨.
            width: MediaQuery.of(context).size.width, // 화면의 너비만큼 이미지를 조정함.
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported,
              color: GRAY88_COLOR,
              size: interval3X,
            ), // 이미지 로드 실패 시 아이콘 표시
          )
        : Icon(
            Icons.image_not_supported,
            color: GRAY88_COLOR,
            size: interval3X,
          ); // 이미지 URL이 없을 때 아이콘 표시
  }

  // 이미지 전체를 볼 수 있는 버튼을 생성하는 함수
  // 버튼을 눌러 이미지를 펼치거나 접는 기능을 제공함.
  Widget buildExpandButton(BuildContext context, WidgetRef ref, String text,
      IconData icon, bool isCollapseButton) {
    final Size screenSize = MediaQuery.of(context).size;
    final double referenceWidth = 393.0; // 기준 화면 너비
    final double referenceHeight = 852.0; // 기준 화면 높이

    final double expandBtnWidth =
        screenSize.width * (345 / referenceWidth); // 버튼 너비 설정
    final double expandBtnHeight =
        screenSize.height * (54 / referenceHeight); // 버튼 높이 설정
    final double expandBtnX =
        screenSize.width * (24 / referenceWidth); // 왼쪽 여백 설정
    final double expandBtnFontSize =
        screenSize.height * (14 / referenceHeight); // 버튼 내 텍스트 크기 설정
    final double expandBtnY =
        screenSize.height * (2 / referenceHeight); // 상단 여백 설정

    // '접기' 버튼은 마지막 이미지를 로드한 후에만 표시됨.
    bool showFullImage = ref.read(showFullImageProvider);
    bool hasMoreImages =
        ref.read(imagesProvider(widget.fullPath).notifier).hasMore;
    bool showCollapseButton =
        ref.watch(imagesProvider(widget.fullPath).notifier).showCollapseButton;

    // 버튼을 보여줄지 여부를 결정
    if (isCollapseButton && hasMoreImages) {
      return SizedBox.shrink(); // 마지막 이미지가 로드되지 않은 상태에서는 '접기' 버튼을 표시하지 않음
    }

    return Container(
      height: expandBtnHeight, // 버튼 높이 설정
      width: expandBtnWidth, // 버튼 너비 설정
      margin: EdgeInsets.only(left: expandBtnX, top: expandBtnY), // 여백 설정
      child: ElevatedButton.icon(
        onPressed: () {
          // showFullImage 상태를 토글함.
          ref.read(showFullImageProvider.notifier).state =
              !showFullImage; // 버튼 클릭 시 이미지 상태 변경
          // '접기' 버튼 숨김 상태 초기화
          if (showFullImage) {
            ref
                .read(imagesProvider(widget.fullPath).notifier)
                .resetButtonState();
          }
          // 이미 모든 데이터를 불러왔으면 바로 접기 버튼 표시
          if (!showFullImage && !hasMoreImages) {
            ref
                .read(imagesProvider(widget.fullPath).notifier)
                .showCollapseButton = true;
          }
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: ORANGE56_COLOR, // 아이콘 및 텍스트 색상 설정
          backgroundColor:
              Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색
          side: BorderSide(color: ORANGE56_COLOR), // 버튼 테두리 색상 설정
        ),
        icon: Icon(icon,
            size: expandBtnFontSize, color: ORANGE56_COLOR), // 아이콘 크기 및 색상 설정
        label: Text(
          text, // 전달받은 텍스트를 버튼에 표시함.
          style: TextStyle(
            fontFamily: 'NanumGothic',
            fontSize: expandBtnFontSize, // 텍스트 크기 설정
            fontWeight: FontWeight.bold, // 텍스트 굵기 설정
            color: ORANGE56_COLOR, // 텍스트 색상 설정
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images =
        ref.watch(imagesProvider(widget.fullPath)); // Firestore에서 이미지 목록을 받아옴.
    bool showFullImage = ref.watch(showFullImageProvider); // 이미지 전체 보기 여부 상태 확인
    bool showCollapseButton = ref
        .watch(imagesProvider(widget.fullPath).notifier)
        .showCollapseButton; // '접기' 버튼 표시 여부
    // bool hasMoreImages = ref.watch(imagesProvider(widget.fullPath).notifier).hasMore;

    final Size screenSize = MediaQuery.of(context).size;
    final double referenceHeight = 852.0; // 기준 화면 높이
    final double productInfoY =
        screenSize.height * (4 / referenceHeight); // 제품 정보 상단 여백 설정

    // 표시할 이미지 리스트 결정
    List<String> imagesToShow = images;

    if (!showFullImage && images.isNotEmpty) {
      imagesToShow = [images.first]; // 전체 이미지가 아닌 경우 첫 번째 이미지만 표시함.
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context, 'PRODUCT INFO'),
        // 상세 정보 섹션 타이틀 표시
        // 이미지 리스트 표시
        Column(
          children: imagesToShow.map((imageUrl) {
            if (imageUrl == images.first && !showFullImage) {
              // 첫 번째 이미지이고 접힌 상태일 때 부분 이미지 표시
              return buildPartialImage(context, imageUrl);
            } else {
              // 그 외에는 전체 이미지 표시
              return buildFullImage(context, imageUrl);
            }
          }).toList(),
        ),
        // SizedBox(height: productInfoY), // 이미지 리스트 아래 여백 설정
        if (!showFullImage)
          buildExpandButton(
              context, ref, '상품 정보 펼쳐보기', Icons.arrow_downward, false),
        // 펼치기 버튼 표시
        // showFullImage 경우와 showCollapseButton 경우 둘 중 하나라도 참인 경우
        if (showFullImage || showCollapseButton)
          buildExpandButton(context, ref, '접기', Icons.arrow_upward, true),
        // 접기 버튼은 마지막 이미지가 로드된 후에만 표시
      ],
    );
  }
}
// -------- 상품 상세 화면 내 상품정보에서 UI로 구현되는 내용 관련 ProductInfoContents 클래스 부분 끝

// ------ 상품 상세 화면 내 리뷰에서 UI로 구현되는 내용 관련 ProductReviewContents 클래스 시작
// ProductReviewContents 클래스는 StatelessWidget을 상속받아 정의됨
// 해당 리뷰 부분은 리뷰 작성 화면에서 작성한 내용을 파이어베이스에 저장 후 저장된 내용을 불러오도록 로직을 재설계해야함!!
class ProductReviewContents extends StatelessWidget {
  // 리뷰 작성자의 이름
  final String reviewerName;

  // 리뷰 작성 날짜
  final String reviewDate;

  // 리뷰 내용
  final String reviewContent;

  // 리뷰 제목
  final String reviewTitle; // 리뷰 제목 추가
  // 리뷰에 첨부된 이미지 리스트
  final List<String> reviewImages; // 리뷰에 첨부된 이미지들
  // 리뷰에서 선택된 색상
  final String reviewSelectedColor; // 선택된 색상 추가
  // 리뷰에서 선택된 사이즈
  final String reviewSelectedSize; // 선택된 사이즈 추가

  // 생성자에서 모든 필드를 필수로 받아 초기화함
  const ProductReviewContents({
    required this.reviewerName,
    required this.reviewDate,
    required this.reviewContent,
    required this.reviewTitle, // 리뷰 제목 추가
    required this.reviewImages, // 리뷰 이미지들 추가
    required this.reviewSelectedColor, // 선택된 색상 추가
    required this.reviewSelectedSize, // 선택된 사이즈 추가
  });

  @override
  Widget build(BuildContext context) {
    // 작성자 이름을 마스킹 처리함
    String maskedReviewerName = reviewerName.isNotEmpty
        ? reviewerName[0] + '*' * (reviewerName.length - 1)
        : '';

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double buildSectionTitleFontSize =
        screenSize.height * (16 / referenceHeight); // 텍스트 크기가 화면 높이에 비례하여 설정됨.
    final double buildSectionWidthX = screenSize.width *
        (8 / referenceWidth); // 텍스트 좌우 여백 크기가 화면 너비에 비례하여 설정됨.
    final double buildSectionLineY = screenSize.height *
        (8 / referenceHeight); // 텍스트 아래 간격이 화면 높이에 비례하여 설정됨.
    final double interval1Y = screenSize.height * (4 / referenceHeight);
    final double reviewDataTextFontSize1 =
        screenSize.height * (14 / referenceHeight);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: BLACK_COLOR, width: 1.0), // 하단 테두리 색상을 설정함
        ),
      ),
      child: CommonCardView(
        // 배경색을 설정함
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // 앱 기본 배경색,
        content: Padding(
          padding: EdgeInsets.zero,
          // 리뷰 내용 전체를 세로로 정렬된 컬럼 위젯으로 구성함
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 작성자 이름을 마스킹 처리된 값으로 출력함
              _buildReviewInfoRow(context, '작성자: ', maskedReviewerName,
                  bold: true),
              SizedBox(height: interval1Y),
              // 작성 일시를 출력함
              _buildReviewInfoRow(context, '등록 일시: ', reviewDate, bold: true),
              SizedBox(height: interval1Y),
              // 선택된 색상 및 사이즈가 존재할 경우 이를 출력함
              if (reviewSelectedColor.isNotEmpty ||
                  reviewSelectedSize.isNotEmpty)
                _buildReviewInfoRow(context, '색상 / 사이즈: ',
                    '$reviewSelectedColor / $reviewSelectedSize',
                    bold: true),
              SizedBox(height: interval1Y),
              // 리뷰 제목이 존재할 경우 이를 출력함
              if (reviewTitle.isNotEmpty)
                _buildReviewInfoColumn(context, '제목: ', reviewTitle,
                    bold: true, fontSize: reviewDataTextFontSize1),
              SizedBox(height: interval1Y),
              // 리뷰 내용이 존재할 경우 이를 출력함
              if (reviewContent.isNotEmpty)
                _buildReviewInfoColumn(context, '내용: ', reviewContent,
                    bold: true, fontSize: reviewDataTextFontSize1),
              SizedBox(height: interval1Y),
              // 리뷰 이미지가 존재할 경우 이를 출력함
              if (reviewImages.isNotEmpty)
                _buildReviewImagesRow(reviewImages, context),
            ],
          ),
        ),
        elevation: 0,
        // 카드뷰 그림자 깊이
      ),
    );
  }

  // 리뷰 정보를 세로로 구성하여 표시하는 함수
  Widget _buildReviewInfoColumn(
      BuildContext context, String label, String value,
      {bool bold = false, double fontSize = 14}) {
    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: interval1Y),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨 텍스트를 출력함
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal, // 라벨 텍스트는 기본 스타일로 표시함
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR, // 텍스트 색상 설정
            ),
          ),
          SizedBox(height: interval2Y),
          // 데이터 텍스트를 출력함
          Text(
            value ?? '',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR, // 텍스트 색상 설정
              fontWeight: bold
                  ? FontWeight.bold
                  : FontWeight.normal, // 데이터 텍스트만 bold로 표시함
            ),
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  // 리뷰 정보를 가로로 구성하여 표시하는 함수
  Widget _buildReviewInfoRow(BuildContext context, String label, String value,
      {bool bold = false, double fontSize = 14}) {
    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.
    final double referenceHeight = 852.0; // 기준 화면 높이를 설정함.

    final double interval1Y = screenSize.height * (2 / referenceHeight);
    final double interval2Y = screenSize.height * (4 / referenceHeight);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: interval1Y),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨 텍스트를 출력함
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.normal, // 라벨 텍스트는 기본 스타일로 표시함
              fontFamily: 'NanumGothic',
              color: BLACK_COLOR, // 텍스트 색상 설정
            ),
          ),
          SizedBox(height: interval2Y),
          // 데이터 텍스트를 확장 가능한 위젯으로 출력함
          Expanded(
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'NanumGothic',
                color: BLACK_COLOR, // 텍스트 색상 설정
                fontWeight: bold
                    ? FontWeight.bold
                    : FontWeight.normal, // 데이터 텍스트만 bold로 표시함
              ),
              textAlign: TextAlign.start,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  // 리뷰 이미지를 가로로 구성하여 표시하는 함수
  Widget _buildReviewImagesRow(List<String> images, BuildContext context) {
    // 화면 너비를 계산함
    final width = MediaQuery.of(context).size.width;
    // 이미지 하나의 너비를 설정함
    final imageWidth = width / 4;

    final Size screenSize = MediaQuery.of(context).size; // 기기의 화면 크기를 동적으로 가져옴.
    final double referenceWidth = 393.0; // 기준 화면 너비를 설정함.

    final double interval1X = screenSize.width * (8 / referenceWidth);
    final double interval2X = screenSize.width * (70 / referenceWidth);

    // 각 이미지를 가로로 나열하여 출력함
    return Row(
      children: images.map((image) {
        return GestureDetector(
          // 이미지를 클릭했을 때 원본 이미지를 보여주는 화면으로 이동함
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailOriginalImageScreen(
                  images: images,
                  initialPage: images.indexOf(image),
                ),
              ),
            );
          },
          // 이미지 컨테이너를 설정함
          child: Container(
            width: imageWidth,
            height: imageWidth,
            margin: EdgeInsets.only(right: interval1X),
            child: AspectRatio(
              aspectRatio: 1,
              // 네트워크에서 이미지를 불러와 출력함
              // 이미지가 있으면 이미지를 표시하고, 없으면 아이콘을 표시
              child: image != null && image!.isNotEmpty
                  ? Image.network(
                      // 네트워크 이미지를 보여주는 위젯
                      image, // 이미지 URL 설정
                      fit: BoxFit.cover, // 이미지가 컨테이너를 가득 채우도록 설정
                      // 이미지 로드 실패 시 아이콘 표시
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: GRAY88_COLOR,
                        size: interval2X,
                      ),
                    )
                  : SizedBox.shrink(), // 이미지 데이터가 없으면 빈 칸
            ),
          ),
        );
      }).toList(),
    );
  }
}
// ------ 상품 상세 화면 내 리뷰에서 UI로 구현되는 내용 관련 ProductReviewContents 클래스 끝

// ------ 상품정보, 리뷰 탭 화면 내 밑줄과 텍스트를 포함하는 UI 위젯을 생성하는 함수 내용 시작 부분
// 제목을 텍스트와 구분선으로 구성함.
Widget buildSectionTitle(BuildContext context, String title) {
  final Size screenSize = MediaQuery.of(context).size;
  final double referenceWidth = 393.0; // 기준 화면 너비
  final double referenceHeight = 852.0; // 기준 화면 높이

  final double buildSectionTitleFontSize =
      screenSize.height * (16 / referenceHeight); // 폰트 크기 설정
  final double buildSectionWidthX =
      screenSize.width * (8 / referenceWidth); // 좌우 여백 설정
  final double buildSectionLineY =
      screenSize.height * (10 / referenceHeight); // 구분선 위 아래 간격 설정

  return Column(
    children: [
      Row(
        children: [
          Expanded(child: Divider(thickness: 3, color: GRAY85_COLOR)),
          // 왼쪽 구분선
          Padding(
            padding: EdgeInsets.only(
                left: buildSectionWidthX, right: buildSectionWidthX),
            // 텍스트 양옆 여백 설정
            child: Text(
              title, // 전달받은 제목을 표시함.
              style: TextStyle(
                fontFamily: 'NanumGothic',
                fontWeight: FontWeight.bold,
                fontSize: buildSectionTitleFontSize, // 텍스트 크기 설정
                color: GRAY85_COLOR, // 텍스트 색상 설정
              ),
            ),
          ),
          Expanded(child: Divider(thickness: 3, color: GRAY85_COLOR)),
          // 오른쪽 구분선
        ],
      ),
      SizedBox(height: buildSectionLineY), // 텍스트와 아래 여백 설정
    ],
  );
}
// ------ 상품정보, 리뷰 탭 화면 내 밑줄과 텍스트를 포함하는 UI 위젯을 생성하는 함수 내용 끝 부분

// ------ 연결된 링크로 이동하는 '상품 문의하기' 버튼을 UI로 구현하는 ProductInquiryContents 클래스 내용 구현 시작
// ProductInquiryContents 클래스는 StatelessWidget을 상속받아 정의됨
class ProductInquiryContents extends StatelessWidget {
  // build 메서드를 오버라이드하여 UI를 구성
  @override
  Widget build(BuildContext context) {
    // MediaQuery로 기기의 화면 크기를 동적으로 가져옴
    final Size screenSize = MediaQuery.of(context).size;

    // 기준 화면 크기: 가로 393, 세로 852
    final double referenceWidth = 393.0;
    final double referenceHeight = 852.0;

    // 비율을 기반으로 동적으로 크기와 위치 설정

    // 버튼 관련 수치 동적 적용
    final double productInquiryBtnFontSize =
        screenSize.height * (14 / referenceHeight);
    final double productInquiryCardViewY =
        screenSize.height * (20 / referenceHeight);

    // CommonCardView 위젯을 반환, content에 Column 위젯을 사용하여 여러 위젯을 세로로 배치
    return CommonCardView(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // 중앙 정렬
        children: [
          // ElevatedButton 위젯을 사용하여 버튼을 생성
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: ORANGE56_COLOR, // 텍스트 색상
              backgroundColor:
                  Theme.of(context).scaffoldBackgroundColor, // 배경 색상
              side: BorderSide(
                color: ORANGE56_COLOR,
              ), // 테두리 색상
            ),
            // 버튼이 눌렸을 때의 동작 정의
            onPressed: () async {
              // 열고자 하는 URL을 url 변수에 상수로 저장함
              const url = 'http://pf.kakao.com/_xjVrbG';
              try {
                // URL을 Uri로 변환하여 외부 브라우저에서 실행함
                final bool launched = await launchUrl(
                  Uri.parse(url), // URL을 Uri 객체로 변환함
                  mode: LaunchMode.externalApplication, // 외부 애플리케이션 실행 모드 설정함
                );

                // URL 실행에 실패한 경우 사용자에게 알림을 표시함
                if (!launched) {
                  showCustomSnackBar(context, '웹 페이지를 열 수 없습니다.');
                }
              } catch (e) {
                // URL 실행 중 예외가 발생한 경우 사용자에게 에러 메시지를 표시함
                showCustomSnackBar(context, '에러가 발생했습니다.\n앱을 재실행해주세요.');
              }
            },
            // 버튼의 자식 위젯으로 텍스트를 설정
            child: Text(
              '상품 문의하기',
              style: TextStyle(
                fontFamily: 'NanumGothic',
                fontSize: productInquiryBtnFontSize,
                fontWeight: FontWeight.bold,
                color: ORANGE56_COLOR,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0.0,
      // 그림자 효과 0
      margin: EdgeInsets.symmetric(
          horizontal: 0.0, vertical: productInquiryCardViewY),
      // 좌우 여백을 0으로 설정.
      padding: const EdgeInsets.all(0.0), // 카드 내부 여백을 0.0으로 설정.
    );
  }
}
// ------ 연결된 링크로 이동하는 '상품 문의하기' 버튼을 UI로 구현하는 ProductInquiryContents 클래스 내용 구현 끝
