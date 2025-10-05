#import <Foundation/Foundation.h>

@interface WKWebView : UIView
@property (nonatomic, copy, readonly) NSURL *URL;
-(void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
@end

// Remove ads & related searches
#define JAVASCRIPT_STRINGS	"document.querySelector('span.attribution-text')?.textContent === 'Related searches' && document.querySelector('span.attribution-text')?.parentElement?.parentElement?.remove();" \
							"Array.from(document.querySelectorAll('div.gcsa-container')).forEach(e => e.remove());" \
							"Array.from(document.querySelectorAll('section.a-bg')).forEach(e => e.remove());"

%hook WBSSearchProvider
-(id)initWithDictionary:(id)dictionary usingContext:(id)context {
	if ([dictionary[@"ParsecSearchIdentifier"] isEqualToString:@"google_search"]) {
		dictionary = @{
			@"GroupIdentifierQueryStringKey": @"safari_group",
			@"HomepageURLs": @[
				@"https://www.startpage.com/"
			],
			@"HostSuffixes": @[
				@".startpage.com"
			],
			@"LocalizedName": @"Startpage", // shows above suggested results in Safari
			@"ParsecSearchEndpointType": @2,
			@"ParsecSearchIdentifier": @"google_search",
			@"ParsecSearchResultType": @9,
			@"ParsecSearchSuggestionIdentifier": @"google_comp",
			@"PathPrefixes": @[
				@"/sp/search",
				@"/do/search"
			],
			// none/moderate/heavy
			@"SafeSearchSuffix": @"&qadf=moderate",
			@"SafeSearchURLQueryParameters": @{
				@"qadf": @"moderate"
			},
			@"ScriptingName": @"Google",
			@"SearchEngineID": @2,
			@"SearchEngineIdentifier": @"com.startpage.www",
			@"SearchURLTemplate": @"https://www.startpage.com/sp/search?query={searchTerms}",
			@"SearchURLTemplateIPad": @"https://www.startpage.com/sp/search?query={searchTerms}",
			@"SearchURLTemplateIPhone": @"https://www.startpage.com/sp/search?query={searchTerms}",
			@"SearchURLTemplateIPodTouch": @"https://www.startpage.com/sp/search?query={searchTerms}",
			@"SearchURLTemplateMac": @"https://www.startpage.com/sp/search?query={searchTerms}",
			@"ShortName": @"Google",
			@"SuggestionsURLTemplate": @"https://www.startpage.com/osuggestions?q={searchTerms}",
			@"SuggestionsURLTemplateMac": @"https://www.startpage.com/osuggestions?q={searchTerms}",
			@"UsesSearchTermsFromFragment": @YES
		};
	}

	return %orig(dictionary, context);
}
%end

%hook WKWebView
-(void)_didFinishNavigation:(id *)arg1 {
	%orig;

	if ([self.URL.absoluteString containsString:@"startpage.com/"]) {
		[self evaluateJavaScript:[NSString stringWithUTF8String:JAVASCRIPT_STRINGS] completionHandler:nil];
	}
}
%end
