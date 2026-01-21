package src5;

public class ChatConfig {
    public static final int DEFAULT_MAX_LENGTH = 100;
    public static final int DEFAULT_RATE_LIMIT_COUNT = 5;
    public static final long DEFAULT_RATE_LIMIT_WINDOW_MS = 3000;
    public static final int DEFAULT_ROOM_HISTORY_LIMIT = 50;
    public static final boolean DEFAULT_LEGACY_EVENTS_ENABLED = true;
    public static final String[] DEFAULT_BLACKLIST = new String[0];

    private final int maxLength;
    private final int rateLimitCount;
    private final long rateLimitWindowMs;
    private final int roomHistoryLimit;
    private final boolean legacyEventsEnabled;
    private final String[] blacklist;

    public ChatConfig(int maxLength,
                      int rateLimitCount,
                      long rateLimitWindowMs,
                      int roomHistoryLimit,
                      boolean legacyEventsEnabled,
                      String[] blacklist) {
        this.maxLength = maxLength;
        this.rateLimitCount = rateLimitCount;
        this.rateLimitWindowMs = rateLimitWindowMs;
        this.roomHistoryLimit = roomHistoryLimit;
        this.legacyEventsEnabled = legacyEventsEnabled;
        this.blacklist = blacklist != null ? blacklist : new String[0];
    }

    public static ChatConfig defaultConfig() {
        return new ChatConfig(
            DEFAULT_MAX_LENGTH,
            DEFAULT_RATE_LIMIT_COUNT,
            DEFAULT_RATE_LIMIT_WINDOW_MS,
            DEFAULT_ROOM_HISTORY_LIMIT,
            DEFAULT_LEGACY_EVENTS_ENABLED,
            DEFAULT_BLACKLIST
        );
    }

    public int getMaxLength() {
        return maxLength;
    }

    public int getRateLimitCount() {
        return rateLimitCount;
    }

    public long getRateLimitWindowMs() {
        return rateLimitWindowMs;
    }

    public int getRoomHistoryLimit() {
        return roomHistoryLimit;
    }

    public boolean isLegacyEventsEnabled() {
        return legacyEventsEnabled;
    }

    public String[] getBlacklist() {
        return blacklist;
    }
}
