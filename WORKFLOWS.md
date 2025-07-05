# ⚙️ AI Threat Intelligence Bulletin - Workflow Guide

> **How the n8n workflow actually works behind the scenes**

I built a single, focused n8n workflow that handles the entire threat intelligence bulletin generation process. It's straightforward - fetch RSS feeds, filter "yesterday" news, let AI categorize threats, and deliver professional bulletins to Discord. Here's how it all works together.

---

## 📰 **ai_generated_bulletin** - The Complete Automation

**What it does**: A comprehensive workflow that runs daily at 10 AM, monitors cybersecurity RSS feeds, uses AI to analyze and categorize threats, then delivers professional bulletins to your Discord channel.

### 🎯 How It Works

This single workflow handles the entire pipeline from RSS monitoring to Discord delivery:

1. **📅 Schedule Trigger** - Runs automatically every day at 10 AM
2. **📡 RSS Collection** - Fetches from 3 major cybersecurity news sources  
3. **🔍 Smart Filtering** - Only processes yesterday's news (no old articles)
4. **🤖 AI Analysis** - Google Gemini reads articles and creates categorized summaries
5. **📱 Discord Delivery** - Sends professional bulletins with file attachments
6. **💾 Database Storage** - Saves everything for historical analysis

### 📡 RSS Data Collection

**Multi-source Monitoring**: The workflow pulls from 3 major cybersecurity sources:

- **Bleeping Computer** (`https://www.bleepingcomputer.com/feed/`) - General cybersecurity news and vulnerabilities
- **Threat Post** (`https://feeds.feedburner.com/TheHackersNews`) - Latest cyber attacks and threat campaigns  
- **Dark Reading** (`https://www.darkreading.com/rss.xml`) - Enterprise security and threat intelligence

**Data Merging**: All RSS feeds get combined into a single stream for processing, ensuring we capture the full threat landscape from multiple perspectives.

### 🔍 Smart Filtering & Validation

**Yesterday's News Only**: 
```javascript
// Filter logic that only keeps yesterday's articles
$json.isoDate?.toDateTime().format('yyyy-MM-dd') === $today.minus(1, 'days').format('yyyy-MM-dd')
```

**Data Quality Check**: Validates that articles have complete information (title, link, content) and filters out any incomplete items. This ensures the AI only processes high-quality, complete articles.

**RSS Feed Standardization**: Extracts and standardizes the key fields (title, link, content) from different RSS formats to create consistent data for AI processing.

### 🤖 AI-Powered Threat Analysis

**Google Gemini 2.0 Flash**: The workflow uses Google's latest LLM to read and understand cybersecurity articles, categorizing threats and creating professional summaries.

**AI Prompt Engineering**: The system uses a sophisticated prompt that instructs the AI to:
- **Categorize threats** by type (Ransomware, APTs, Phishing, etc.)
- **Create concise summaries** with key threat details
- **Add relevant hashtags** for categorization (#ransomware, #apt, #phishing)
- **Include source links** using `[🔗¹](link)` format
- **Generate professional markdown** suitable for security professionals

**Think Tool Integration**: Connected to an AI reasoning tool that helps the AI agent process complex threat intelligence more effectively.

### 📝 Bulletin Generation & Structure

**Professional Format**: The AI generates bulletins in structured markdown format:

```markdown
## 🛠️ Tools & Techniques
- **Tool Name:** Brief description with threat implications [🔗¹](source) [🔗²](source2) #hashtags

## 💥 Ransomware  
- **Campaign Name:** Summary of ransomware activity and impact [🔗¹](source) #ransomware

## 🎣 Phishing & Social Engineering
- **Attack Type:** Description of phishing campaign or social engineering tactics [🔗¹](source) #phishing
```

**Dynamic Titles**: Automatically generates titles like "Threat Intel Bulletin [January 15, 2025]" using the current date.

**Source Tracking**: Captures all source URLs in a structured format for attribution and follow-up research.

### 📱 Discord Integration & Notifications

**Three-Stage Communication**:

1. **🔄 Bulletin Init** - Sends "generation started" notification with blue embed
2. **✅ Successful Delivery** - Rich embed with bulletin title, timestamp, and attached markdown file  
3. **⚠️ Error Handling** - Red error notification if anything fails during processing

**Rich Embeds**: Uses Discord's embed system to create professional-looking notifications with:
- Color-coded status (blue for processing, green for success, red for errors)
- Timestamps and bulletin metadata
- File attachments with the complete markdown bulletin

### 💾 Database Persistence

**Supabase Storage**: Every bulletin gets saved to the `bulletins` table with:
- **Title**: Auto-generated bulletin title with date
- **Content**: Full markdown content with categorized threats
- **Sources**: Array of all source URLs for reference
- **Language**: Currently English (en-US), expandable for multi-language
- **Delivery Status**: Tracks whether bulletin was successfully sent to Discord

### ⚠️ Error Handling & Reliability

**Minimal Error Management**: The workflow includes multiple error handling paths:
- **AI Processing Failures** - Sends Discord error notification and stops execution
- **Database Issues** - Continues with Discord delivery even if database save fails
- **Discord Delivery Problems** - Updates database status accordingly

**Retry Logic**: AI analysis includes retry mechanisms with 5-second delays between attempts to handle temporary API issues.

**Graceful Degradation**: If any step fails, the workflow provides clear error messages to Discord for debugging.

## 🎯 Key Features

- **🕙 Daily Automation** - Set-and-forget 10 AM schedule
- **📡 Multi-source RSS** - 3 major cybersecurity news sources
- **🔍 Smart Date Filtering** - Only yesterday's news, no duplicates
- **🤖 AI Categorization** - Professional threat intelligence summaries
- **📱 Discord Delivery** - Rich embeds with file attachments  
- **💾 Historical Storage** - Database persistence for future analysis
- **⚠️ Error Monitoring** - Automatic failure notifications

## 📊 Performance & Limitations

**Processing Speed**: Typical execution takes about ~1 minute depending on:
- Number of articles from RSS feeds (usually 10-30 per day)
- AI processing time for threat categorization
- Discord API response times

**Google Gemini Limits**: 
- **Free tier** works well for daily bulletins (1 request per day)
- **Rate limits** rarely hit with this usage pattern
- **Backup plan** ready to switch to other AI models if needed

**Dependencies**: 
- RSS feeds must be accessible (rare outages possible)
- Google Gemini API availability
- Discord webhook functionality
- Supabase database connectivity

---

<div align="center">

**⚙️ Want to understand how to deploy this?**

[📖 Setup Guide](SETUP.md) • [🏠 Project Overview](README.md)

Just a guy documenting his automation workflows 🛠️

</div>