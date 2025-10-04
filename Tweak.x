// WBSOpenSearchURLTemplate *__cdecl -[WBSSearchProvider searchURLTemplate](WBSSearchProvider *self, SEL);
// WBSOpenSearchURLTemplate *__cdecl -[WBSSearchProvider safeSearchURLTemplate](WBSSearchProvider *self, SEL);
// NSDictionary *__cdecl -[WBSSearchProvider safeSearchURLQueryParameters](WBSSearchProvider *self, SEL);
// WBSOpenSearchURLTemplate *__cdecl -[WBSSearchProvider suggestionsURLTemplate](WBSSearchProvider *self, SEL);

// -(id)userVisibleQueryFromSearchURL:(id)arg0 ;
// -(id)userVisibleQueryFromSearchURL:(id)arg0 allowQueryThatLooksLikeURL:(BOOL)arg1 ;

#import <Foundation/Foundation.h>

@interface WKWebView : UIView
@property (nonatomic, copy, readonly) NSURL *URL;
-(void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler;
@end

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

/*

// Commented since adding /do/search to PathPrefixes solves the issue

-(id)userVisibleQueryFromSearchURL:(NSURL *)searchURL allowQueryThatLooksLikeURL:(BOOL)allowQueryThatLooksLikeURL {
	NSString *urlString = [searchURL absoluteString];
	if ([urlString containsString:@"startpage.com/do/search"]) {
		urlString = [urlString stringByReplacingOccurrencesOfString:@"startpage.com/do/search" withString:@"startpage.com/sp/search"];
		searchURL = [NSURL URLWithString:urlString];
	}

	return %orig(searchURL, allowQueryThatLooksLikeURL);
}*/
%end


// removes the "Related searches" section at the top of Startpage when on mobile
%hook WKWebView
-(void)_didFinishNavigation:(id *)arg1 {
	%orig;

	if ([self.URL.absoluteString containsString:@"startpage.com/"]) {
		[self evaluateJavaScript:@"document.querySelector('span.attribution-text')?.textContent.trim() === 'Related searches' && document.querySelector('span.attribution-text')?.parentElement?.parentElement?.remove();" completionHandler:nil];
	}
}
%end
