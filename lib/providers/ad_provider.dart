// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter_admob/models/ad_state_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class AdProvider with ChangeNotifier {
  AdState _adState = AdState();
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  AdState get adState => _adState;
  BannerAd? get bannerAd => _bannerAd;

  void initializeAds() {
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }

  void _loadBannerAd() {
    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        _adState = _adState.copyWith(bannerAdState: AdLoadState.loaded);
        notifyListeners();
      },
      onAdFailedToLoad: (ad, error) {
        log('Ad failed to load: ${error.code} - ${error.message}');
        log('Domain: ${error.domain}');
        log('Response Info: ${error.responseInfo}');
        _adState = _adState.copyWith(bannerAdState: AdLoadState.failed);
        ad.dispose();
        notifyListeners();
      },
    );
    _bannerAd!.load();
  }

  void _loadInterstitialAd() {
    AdService.loadInterstitialAd(
      onAdLoaded: (ad) {
        _interstitialAd = ad;
        _adState = _adState.copyWith(interstitialAdState: AdLoadState.loaded);
        notifyListeners();
      },
      onAdFailedToLoad: (error) {
        _adState = _adState.copyWith(interstitialAdState: AdLoadState.failed);
        notifyListeners();
      },
    );
  }

  void _loadRewardedAd() {
    AdService.loadRewardedAd(
      onAdLoaded: (ad) {
        _rewardedAd = ad;
        _adState = _adState.copyWith(rewardedAdState: AdLoadState.loaded);
        notifyListeners();
      },
      onAdFailedToLoad: (error) {
        _adState = _adState.copyWith(rewardedAdState: AdLoadState.failed);
        notifyListeners();
      },
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _adState = _adState.copyWith(interstitialAdState: AdLoadState.loading);
      _loadInterstitialAd(); // Load next ad
      notifyListeners();
    }
  }

  void showRewardedAd() {
    if (_rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          _adState = _adState.copyWith(
            rewardedAdPoints: _adState.rewardedAdPoints + reward.amount.toInt(),
          );
          notifyListeners();
        },
      );
      _rewardedAd = null;
      _adState = _adState.copyWith(rewardedAdState: AdLoadState.loading);
      _loadRewardedAd(); // Load next ad
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    super.dispose();
  }
}
