package uk.co.cerihughes.denon.core.dao.impl.recent;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

public class RecentsSQLiteHelper extends SQLiteOpenHelper
{
	private static final String TABLE_NAME = "recents";
	private static final String COLUMN_ID = "_id";
	private static final String DAO_ID = "dao_id";
	private static final String ITEM_ID = "item_id";
	private static final String COLUMN_LAST_USED = "last_used";
	private static final String DATABASE_NAME = "recents.db";
	private static final int DATABASE_VERSION = 1;

	// Database creation sql statement
	private static final String DATABASE_CREATE = "create table " + TABLE_NAME + "(" + COLUMN_ID + " integer primary key autoincrement, "
			+ DAO_ID + " text not null, " + ITEM_ID + " text not null, " + COLUMN_LAST_USED + " int not null);";

	public RecentsSQLiteHelper(Context context)
	{
		super(context, DATABASE_NAME, null, DATABASE_VERSION);
	}

	@Override
	public void onCreate(SQLiteDatabase database)
	{
		database.execSQL(DATABASE_CREATE);
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion)
	{
		Log.w(RecentsSQLiteHelper.class.getName(), "Upgrading database from version " + oldVersion + " to " + newVersion
				+ ", which will destroy all old data");
		db.execSQL("DROP TABLE IF EXISTS " + TABLE_NAME);
		onCreate(db);
	}

}