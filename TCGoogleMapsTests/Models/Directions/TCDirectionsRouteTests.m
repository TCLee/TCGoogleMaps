//
//  TCDirectionsRouteTests.m
//  TCGoogleMaps
//
//  Created by Lee Tze Cheun on 9/3/13.
//  Copyright (c) 2013 Lee Tze Cheun. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

#import "TCDirectionsRouteTests.h"
#import "TCTestData.h"
#import "TCDirectionsRoute.h"
#import "TCDirectionsLeg.h"

@implementation TCDirectionsRouteTests

- (void)testInitWithValidProperties
{
    id serviceResponse = [TCTestData JSONObjectFromFilename:@"TCDirectionsServiceTests_OneRoute"];
    TCDirectionsRoute *route = [[TCDirectionsRoute alloc] initWithProperties:serviceResponse[@"routes"][0]];
    
    STAssertEqualObjects(route.summary, @"I-55 S", @"Route's summary property should match test data value.");
    STAssertEqualObjects([route.overviewPath encodedPath], @"eir~FdezuOdNxDAbVAbINtd@_DxWjJ^`VuDbdAeDzk@pGb^iJhKla@|r@dzBdBjfAdj@lhCdvB`yJpeAhlFlQ`n@v@fn@zOv\\lt@`s@v|@niA|`Avy@`Th`CdChfE~Q~aArn@rkBps@nqAhu@fwCdt@tqCnjBdnEjyGr|OvqBlbFxm@`jAdZtObuEA`v@jD~UxRnz@teApe@lOlrEsDvlCl{Aj`@hPrnAHnaDiDffC_HxwHsMjxMyMf]jFdXdQdUz^xi@|zAtfAf}Ab`BzfAlxCps@lhAxdAd}AjvBrrCxyDbz@t~@jnAnX`YlS~iH`vJx[nl@~f@bsEdNjjA~Pn]nZ|R|\\tDv~CfZ~Y~QtbBrzBnbDhaDrWnk@tb@|yB`^f\\vgD|r@rjCrzB~iA~dAj[jg@`bB~sEpvCdbIrUlW|XpJzeAT`yEJ|eCnkAnpAxx@z{Bjl@nzAt_@h_CjpAruAtkB`T|Hja@HjhCfA~xFtwCveArj@b^nSdMpTxUt}BdUdq@tx@l_@|`Bhj@tv@zQbRtPpmCzkEf^hv@rbAfzDlrAnvAtc@bIfPnNd|AnoClQjp@nAl_@gGru@rA|hDcCnoEpQtl@bh@fNpvF|Ef`AX`m@fJ~YpCd_@}HrtAii@va@e@|fAh}@zcBnhBnjB`fAzYruAt|AjoBrnCvkBjx@xmBrg@d~@zfBfnBlhAjg@vc@heAxQrj@xh@fv@pyBziCl\\dHls@bNbz@h~@rPho@lXzoAvtAvcBrgEjhFl~ArfA`[~`EnGxoLvTv_@|SdGz~@e@lyJuGpa@fNb\\rW~u@nm@hi@vk@x\\bh@~oAnj@npCbzBjw@l{@x]frA`O~RrVfJliAvSfeCb~BlpAhtAb`ApxBde@pNla@y@lYjJ~jDv{Cf]p{@hVnHre@yHjeA~IncBfCroF}QrwCmAdeCz`@lpEzr@|`@br@b]v`AvTt~Av`@jT|qBy@twCiJts@`E`\\h@b]lUliFbAndDeAvso@eXj}WmHh_AvXbiDlxBbnGr|DllHpyE|z@xk@rh@nm@~k@zx@fcAnIrkE[xl@yLv_AaVjtFu@`t@KbWtIn_Bf{BnmBzsC`vAz}Av}AvyAhxAfcAvrJ|aG~sBboAbcBl[p{GbmAxhEzv@hY`Z~_@xaBhRruB|T|qBvTjuAbXni@jmArpAnw@dhA|n@lgD|b@lwCQprDdWv}@p~AlhCzo@~k@tJzU`@fd@z^~tAxKpOrj@~JzQfMpEvSoVpcB_Otk@eIzI_LaJcFzCsAbJwAnJ",
                         @"Route's overview path property should match test data value.");

    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake(41.8781139, -87.6297872)
                                                                       coordinate:CLLocationCoordinate2DMake(38.6156205, -90.1991661)];
    STAssertEquals(route.bounds.northEast, bounds.northEast, @"Route's bounds property should match test data value.");
    STAssertEquals(route.bounds.southWest, bounds.southWest, @"Route's bounds property should match test data value.");
    
    for (id leg in route.legs) {
        STAssertTrue([leg isKindOfClass:[TCDirectionsLeg class]],
                     @"Leg should be of class TCDirectionsLeg.");
    }
    
    STAssertEquals([route.legs count], (NSUInteger)1, @"There should only be one leg in the route.");
}

- (void)testInitWithNilPropertiesShouldReturnNil
{
    TCDirectionsRoute *route = [[TCDirectionsRoute alloc] initWithProperties:nil];
    STAssertNil(route, @"Route should be nil if attemp to initialize with nil properties.");
}

@end
