const _globalThis = typeof window === 'undefined' ? global : window
const Project = {
  api: (typeof process !== 'undefined' && process.env && process.env.FLAGSMITH_PORT) ? `http://localhost:${process.env.FLAGSMITH_PORT}/api/v1/` : 'http://localhost:8005/api/v1/',







  chargebee: {
    site: 'flagsmith-test',
  },

  debug: false,

  env: 'dev',

  flagsmith: 'ENktaJnfLVbLifybz34JmX',


  flagsmithClientAPI: 'https://edge.api.flagsmith.com/api/v1/',

  flagsmithClientEdgeAPI: 'https://edge.api.flagsmith.com/api/v1/',

  flagsmithClientEventsAPI: 'https://events.bullet-train-staging.win/',
  // This is used for Sentry tracking
  maintenance: false,
  plans: {
    scaleUp: {
      annual: 'Scale-Up-v4-USD-Yearly',
      monthly: 'Scale-Up-v4-USD-Monthly',
    },
    startup: { annual: 'startup-annual-v2', monthly: 'startup-v2' },
  },
  useSecureCookies: false,
  ...(_globalThis.projectOverrides || {}),
}
_globalThis.Project = Project
export default Project
