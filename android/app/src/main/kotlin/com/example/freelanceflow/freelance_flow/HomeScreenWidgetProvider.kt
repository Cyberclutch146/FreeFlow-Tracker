package com.example.freelanceflow.freelance_flow

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class HomeScreenWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
                val unconfirmedCount = widgetData.getString("unconfirmed_count", "0")
                setTextViewText(R.id.widget_value, unconfirmedCount)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
