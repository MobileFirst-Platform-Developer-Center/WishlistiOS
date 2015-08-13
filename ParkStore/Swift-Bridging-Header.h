/**
 * Copyright 2015 IBM Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "SWRevealViewController.h"

#import <Foundation/Foundation.h>
#import <CloudantSync.h>
#import <IMFData/IMFData.h>
#import <CloudantToolkit/CloudantToolkit.h>
//#import "DDASLLogger.h"
//#import "DDTTYLogger.h"
//#import "DDFileLogger.h"


//MFP headers
#import "AbstractAcquisitionError.h"
#import "AbstractGeoAreaTrigger.h"
#import "AbstractGeoDwellTrigger.h"
#import "AbstractPosition.h"
#import "AbstractTrigger.h"
#import "AbstractWifiAreaTrigger.h"
#import "AbstractWifiDwellTrigger.h"
#import "AbstractWifiFilterTrigger.h"
#import "AcquisitionCallback.h"
#import "AcquisitionFailureCallback.h"
#import "BaseChallengeHandler.h"
#import "BaseDeviceAuthChallengeHandler.h"
#import "BaseProvisioningChallengeHandler.h"
#import "ChallengeHandler.h"
#import "JSONStore.h"
#import "JSONStoreAddOptions.h"
#import "JSONStoreCollection.h"
#import "JSONStoreOpenOptions.h"
#import "JSONStoreQueryOptions.h"
#import "JSONStoreQueryPart.h"
#import "OCLogger.h"
#import "WLAcquisitionFailureCallbacksConfiguration.h"
#import "WLAcquisitionPolicy.h"
#import "WLAnalytics.h"
#import "WLArea.h"
#import "WLAuthorizationManager.h"
#import "WLCallbackFactory.h"
#import "WLChallengeHandler.h"
#import "WLCircle.h"
#import "WLClient.h"
#import "WLConfidenceLevel.h"
#import "WLCookieExtractor.h"
#import "WLCoordinate.h"
#import "WLDelegate.h"
#import "WLDevice.h"
#import "WLDeviceAuthManager.h"
#import "WLDeviceContext.h"
#import "WLEventSourceListener.h"
#import "WLEventTransmissionPolicy.h"
#import "WLFailResponse.h"
#import "WLGeoAcquisitionPolicy.h"
#import "WLGeoCallback.h"
#import "WLGeoDwellInsideTrigger.h"
#import "WLGeoDwellOutsideTrigger.h"
#import "WLGeoEnterTrigger.h"
#import "WLGeoError.h"
#import "WLGeoExitTrigger.h"
#import "WLGeoFailureCallback.h"
#import "WLGeoPosition.h"
#import "WLGeoPositionChangeTrigger.h"
#import "WLGeoTrigger.h"
#import "WLGeoUtils.h"
#import "WLLocationServicesConfiguration.h"
#import "WLOnReadyToSubscribeListener.h"
#import "WLPolygon.h"
#import "WLProcedureInvocationData.h"
#import "WLProcedureInvocationResult.h"
#import "WLPush.h"
#import "WLPushOptions.h"
#import "WLResourceRequest.h"
#import "WLResponse.h"
#import "WLResponseListener.h"
#import "WLSecurityUtils.h"
#import "WLSimpleDataSharing.h"
#import "WLTriggerCallback.h"
#import "WLTriggersConfiguration.h"
#import "WLTrusteer.h"
#import "WLUserCertAuth.h"
#import "WLWifiAccessPoint.h"
#import "WLWifiAccessPointFilter.h"
#import "WLWifiAcquisitionCallback.h"
#import "WLWifiAcquisitionPolicy.h"
#import "WLWifiConnectTrigger.h"
#import "WLWifiConnectedCallback.h"
#import "WLWifiDisconnectTrigger.h"
#import "WLWifiDwellInsideTrigger.h"
#import "WLWifiDwellOutsideTrigger.h"
#import "WLWifiEnterTrigger.h"
#import "WLWifiError.h"
#import "WLWifiExitTrigger.h"
#import "WLWifiFailureCallback.h"
#import "WLWifiLocation.h"
#import "WLWifiTrigger.h"
#import "WLWifiVisibleAccessPointsChangeTrigger.h"

