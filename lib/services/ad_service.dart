// ignore_for_file: depend_on_referenced_packages

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // Test Ad Unit IDs (replace with your actual IDs in production)
  static const String bannerAdUnitId = 'ca-app-pub-3940256099942544/9214589741';
  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';
  static const String rewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  static Future<void> initialize() async {
    // Configure test settings first
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: <String>[],
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.no,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.no,
    );
    MobileAds.instance.updateRequestConfiguration(configuration);

    await MobileAds.instance.initialize();
    await Future.delayed(const Duration(seconds: 3));
  }

  static BannerAd createBannerAd({
    required Function(Ad) onAdLoaded,
    required Function(Ad, LoadAdError) onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static void loadInterstitialAd({
    required Function(InterstitialAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }

  static void loadRewardedAd({
    required Function(RewardedAd) onAdLoaded,
    required Function(LoadAdError) onAdFailedToLoad,
  }) {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: onAdFailedToLoad,
      ),
    );
  }
}
